#include <string>
#include <vector>
#include <set>
#include <map>
#include <stdexcept>
#include "simPlusPlus/Plugin.h"
#include "simPlusPlus/Handle.h"
#include "config.h"
#include "plugin.h"
#include "stubs.h"
#include "zmq.h"

using sim::Handle;
using sim::Handles;

typedef void zmq_context_t;
typedef void zmq_socket_t;
template<> std::string Handle<void>::tag() { return "simZMQ.*"; }
template<> std::string Handle<zmq_msg_t>::tag() { return "simZMQ.msg"; }

class Plugin : public sim::Plugin
{
public:
    void onStart()
    {
        if(!registerScriptStuff())
            throw std::runtime_error("failed to register script stuff");

        sim::registerScriptVariable("simZMQ.EADDRINUSE", EADDRINUSE, 0);
        sim::registerScriptVariable("simZMQ.EADDRNOTAVAIL", EADDRNOTAVAIL, 0);
        sim::registerScriptVariable("simZMQ.EAGAIN", EAGAIN, 0);
        sim::registerScriptVariable("simZMQ.EFAULT", EFAULT, 0);
        sim::registerScriptVariable("simZMQ.EFSM", EFSM, 0);
        sim::registerScriptVariable("simZMQ.EHOSTUNREACH", EHOSTUNREACH, 0);
        sim::registerScriptVariable("simZMQ.EINTR", EINTR, 0);
        sim::registerScriptVariable("simZMQ.EINVAL", EINVAL, 0);
        sim::registerScriptVariable("simZMQ.EMFILE", EMFILE, 0);
        sim::registerScriptVariable("simZMQ.EMTHREAD", EMTHREAD, 0);
        sim::registerScriptVariable("simZMQ.ENOCOMPATPROTO", ENOCOMPATPROTO, 0);
        sim::registerScriptVariable("simZMQ.ENODEV", ENODEV, 0);
        sim::registerScriptVariable("simZMQ.ENOENT", ENOENT, 0);
        sim::registerScriptVariable("simZMQ.ENOMEM", ENOMEM, 0);
        sim::registerScriptVariable("simZMQ.ENOTSOCK", ENOTSOCK, 0);
        sim::registerScriptVariable("simZMQ.ENOTSUP", ENOTSUP, 0);
        sim::registerScriptVariable("simZMQ.EPROTONOSUPPORT", EPROTONOSUPPORT, 0);
        sim::registerScriptVariable("simZMQ.ETERM", ETERM, 0);

#include "zmq_constants.cpp"

        setExtVersion("ZeroMQ Plugin");
        setBuildDate(BUILD_DATE);
    }

    void onEnd()
    {
        if(global_context)
        {
            if(zmq_ctx_shutdown(global_context) == -1)
                switch(zmq_errno())
                {
                case EFAULT:
                    sim::addLog(sim_verbosity_errors, "zmq_ctx_shutdown: EFAULT");
                    break;
                default:
                    sim::addLog(sim_verbosity_errors, "zmq_ctx_shutdown: unknown error");
                    break;
                }
            if(zmq_ctx_destroy(global_context) == -1)
                switch(zmq_errno())
                {
                case EFAULT:
                    sim::addLog(sim_verbosity_errors, "zmq_ctx_destroy: EFAULT");
                    break;
                case EINTR:
                    sim::addLog(sim_verbosity_errors, "zmq_ctx_destroy: EINTR");
                    break;
                default:
                    sim::addLog(sim_verbosity_errors, "zmq_ctx_destroy: unknown error");
                    break;
                }
            global_context = nullptr;
        }
    }

    void onScriptStateDestroyed(int scriptID)
    {
        for(auto msg : msgHandles.find(scriptID))
        {
            delete msgHandles.remove(msg);
        }
        for(auto socket : socketHandles.find(scriptID))
        {
            void *s = const_cast<void*>(socket);
            zmq_close(s);
            socketHandles.remove(socket);
        }
        for(auto context : contextHandles.find(scriptID))
        {
            void *c = const_cast<void*>(context);
            zmq_term(c);
            zmq_ctx_destroy(c);
            contextHandles.remove(context);
        }
    }

    void bind(bind_in *in, bind_out *out)
    {
        void *socket = socketHandles.get(in->socket);
        out->result = zmq_bind(socket, in->endpoint.c_str());
    }

    void close(close_in *in, close_out *out)
    {
        void *socket = socketHandles.get(in->socket);
        out->result = zmq_close(socket);
        socketHandles.remove(socket);
    }

    void connect(connect_in *in, connect_out *out)
    {
        void *socket = socketHandles.get(in->socket);
        out->result = zmq_connect(socket, in->endpoint.c_str());
    }

    void ctx_get(ctx_get_in *in, ctx_get_out *out)
    {
        void *context = contextHandles.get(in->context);
        out->result = zmq_ctx_get(context, in->option_name);
    }

    void ctx_new(ctx_new_in *in, ctx_new_out *out)
    {
        void *context = zmq_ctx_new();
        out->context = contextHandles.add(context, in->_.scriptID);
    }

    void ctx_set(ctx_set_in *in, ctx_set_out *out)
    {
        void *context = contextHandles.get(in->context);
        out->result = zmq_ctx_set(context, in->option_name, in->option_value);
    }

    void ctx_shutdown(ctx_shutdown_in *in, ctx_shutdown_out *out)
    {
        void *context = contextHandles.get(in->context);
        if(global_context && context == global_context)
            throw std::runtime_error("singleton context must not be shutdown");
        out->result = zmq_ctx_shutdown(context);
    }

    void ctx_term(ctx_term_in *in, ctx_term_out *out)
    {
        void *context = contextHandles.get(in->context);
        if(global_context && context == global_context)
            throw std::runtime_error("singleton context must not be terminated");
        out->result = zmq_ctx_term(context);
        contextHandles.remove(context);
    }

    void ctx_singleton(ctx_singleton_in *in, ctx_singleton_out *out)
    {
        if(!global_context)
            global_context = zmq_ctx_new();
        // don't map global_context to handles: it wil be destroyed in onEnd()
        out->context = Handle<zmq_context_t>::str(global_context);
    }

    void disconnect(disconnect_in *in, disconnect_out *out)
    {
        void *socket = socketHandles.get(in->socket);
        out->result = zmq_disconnect(socket, in->endpoint.c_str());
    }

    void errnum(errnum_in *in, errnum_out *out)
    {
        out->result = zmq_errno();
    }

    void getsockopt(getsockopt_in *in, getsockopt_out *out)
    {
        void *socket = socketHandles.get(in->socket);
        std::string buf(in->option_len, 0);
        size_t len = in->option_len;
        out->result = zmq_getsockopt(socket, in->option_name, reinterpret_cast<void*>(buf.data()), &len);
    }

    void has(has_in *in, has_out *out)
    {
        out->result = zmq_has(in->capability.c_str());
    }

    void msg_close(msg_close_in *in, msg_close_out *out)
    {
        zmq_msg_t *msg = msgHandles.get(in->msg);
        out->result = zmq_msg_close(msg);
    }

    void msg_copy(msg_copy_in *in, msg_copy_out *out)
    {
        zmq_msg_t *dest = msgHandles.get(in->dest);
        zmq_msg_t *src = msgHandles.get(in->src);
        out->result = zmq_msg_copy(dest, src);
    }

    void msg_data(msg_data_in *in, msg_data_out *out)
    {
        zmq_msg_t *msg = msgHandles.get(in->msg);
        void *data = zmq_msg_data(msg);
        if(data)
            out->data = std::string(reinterpret_cast<const char*>(data), zmq_msg_size(msg));
    }

    void msg_destroy(msg_destroy_in *in, msg_destroy_out *out)
    {
        zmq_msg_t *msg = msgHandles.get(in->msg);
        delete msgHandles.remove(msg);
    }

    void msg_gets(msg_gets_in *in, msg_gets_out *out)
    {
        zmq_msg_t *msg = msgHandles.get(in->msg);
        const char *s = zmq_msg_gets(msg, in->property.c_str());
        out->result = s ? 0 : -1;
        if(s) out->value = s;
    }

    void msg_get(msg_get_in *in, msg_get_out *out)
    {
        zmq_msg_t *msg = msgHandles.get(in->msg);
        out->result = zmq_msg_get(msg, in->property);
    }

    void msg_init_size(msg_init_size_in *in, msg_init_size_out *out)
    {
        zmq_msg_t *msg = msgHandles.get(in->msg);
        out->result = zmq_msg_init_size(msg, in->size);
    }

    void msg_init(msg_init_in *in, msg_init_out *out)
    {
        zmq_msg_t *msg = msgHandles.get(in->msg);
        out->result = zmq_msg_init(msg);
    }

    void msg_more(msg_more_in *in, msg_more_out *out)
    {
        zmq_msg_t *msg = msgHandles.get(in->msg);
        out->result = zmq_msg_more(msg);
    }

    void msg_move(msg_move_in *in, msg_move_out *out)
    {
        zmq_msg_t *dest = msgHandles.get(in->dest);
        zmq_msg_t *src = msgHandles.get(in->src);
        out->result = zmq_msg_move(dest, src);
    }

    void msg_new(msg_new_in *in, msg_new_out *out)
    {
        zmq_msg_t *msg = new zmq_msg_t;
        out->msg = msgHandles.add(msg, in->_.scriptID);
    }

    void msg_recv(msg_recv_in *in, msg_recv_out *out)
    {
        zmq_msg_t *msg = msgHandles.get(in->msg);
        void *socket = socketHandles.get(in->socket);
        out->result = zmq_msg_recv(msg, socket, in->flags);
    }

    void msg_send(msg_send_in *in, msg_send_out *out)
    {
        zmq_msg_t *msg = msgHandles.get(in->msg);
        void *socket = socketHandles.get(in->socket);
        out->result = zmq_msg_send(msg, socket, in->flags);
    }

    void msg_set(msg_set_in *in, msg_set_out *out)
    {
        zmq_msg_t *msg = msgHandles.get(in->msg);
        out->result = zmq_msg_set(msg, in->property, in->value);
    }

    void msg_size(msg_size_in *in, msg_size_out *out)
    {
        zmq_msg_t *msg = msgHandles.get(in->msg);
        out->result = zmq_msg_size(msg);
    }

    void poll(poll_in *in, poll_out *out)
    {
        if(in->sockets.size() != in->events.size())
            throw std::runtime_error("'sockets' and 'events' must have the same length");
        int n = in->sockets.size();
        zmq_pollitem_t *items = new zmq_pollitem_t[n];
        for(size_t i = 0; i < n; i++)
        {
            items[i].socket = socketHandles.get(in->sockets[i]);
            items[i].events = in->events[i];
        }
        out->result = zmq_poll(items, n, in->timeout);
        for(size_t i = 0; i < n; i++)
            out->revents.push_back(items[i].revents);
        delete[] items;
    }

    void proxy_steerable(proxy_steerable_in *in, proxy_steerable_out *out)
    {
        void *frontend = socketHandles.get(in->frontend);
        void *backend = socketHandles.get(in->backend);
        void *capture = socketHandles.get(in->capture);
        void *control = socketHandles.get(in->control);
        out->result = zmq_proxy_steerable(frontend, backend, capture, control);
    }

    void proxy(proxy_in *in, proxy_out *out)
    {
        void *frontend = socketHandles.get(in->frontend);
        void *backend = socketHandles.get(in->backend);
        void *capture = socketHandles.get(in->capture);
        out->result = zmq_proxy(frontend, backend, capture);
    }

    void recv(recv_in *in, recv_out *out)
    {
        void *socket = socketHandles.get(in->socket);
        std::string buf(in->max_buf_size, 0);
        out->result = zmq_recv(socket, buf.data(), in->max_buf_size, in->flags);
        if(out->result != -1)
            out->data = buf.substr(0, out->result);
    }

    void send(send_in *in, send_out *out)
    {
        void *socket = socketHandles.get(in->socket);
        out->result = zmq_send(socket, in->data.data(), in->data.size(), in->flags);
    }

    void setsockopt(setsockopt_in *in, setsockopt_out *out)
    {
        void *socket = socketHandles.get(in->socket);
        out->result = zmq_setsockopt(socket, in->option_name, in->option_value.c_str(), in->option_value.size());
    }

    void socket_monitor(socket_monitor_in *in, socket_monitor_out *out)
    {
        void *socket = socketHandles.get(in->socket);
        out->result = zmq_socket_monitor(socket, in->endpoint.c_str(), in->events);
    }

    void socket(socket_in *in, socket_out *out)
    {
        void *context = contextHandles.get(in->context);
        void *socket = zmq_socket(context, in->type);
        out->socket = socketHandles.add(socket, in->_.scriptID);
    }

    void strerror(strerror_in *in, strerror_out *out)
    {
        out->message = zmq_strerror(in->errnum);
    }

    void unbind(unbind_in *in, unbind_out *out)
    {
        void *socket = socketHandles.get(in->socket);
        out->result = zmq_unbind(socket, in->endpoint.c_str());
    }

    void version(version_in *in, version_out *out)
    {
        zmq_version(&out->major, &out->minor, &out->patch);
    }

private:
    void *global_context = nullptr;
    Handles<void> contextHandles;
    Handles<void> socketHandles;
    Handles<zmq_msg_t> msgHandles;
};

SIM_PLUGIN(PLUGIN_NAME, PLUGIN_VERSION, Plugin)
#include "stubsPlusPlus.cpp"
