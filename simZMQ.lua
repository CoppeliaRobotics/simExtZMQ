local simZMQ={}

simZMQ.__const={
    EPERM=1,
    ENOENT=2,
    ESRCH=3,
    EINTR=4,
    EIO=5,
    ENXIO=6,
    E2BIG=7,
    ENOEXEC=8,
    EBADF=9,
    ECHILD=10,
    EDEADLK=11,
    ENOMEM=12,
    EACCES=13,
    EFAULT=14,
    ENOTBLK=15,
    EBUSY=16,
    EEXIST=17,
    EXDEV=18,
    ENODEV=19,
    ENOTDIR=20,
    EISDIR=21,
    EINVAL=22,
    ENFILE=23,
    EMFILE=24,
    ENOTTY=25,
    ETXTBSY=26,
    EFBIG=27,
    ENOSPC=28,
    ESPIPE=29,
    EROFS=30,
    EMLINK=31,
    EPIPE=32,
    EDOM=33,
    ERANGE=34,
    EAGAIN=35,
    EWOULDBLOCK=35,
    EINPROGRESS=36,
    EALREADY=37,
    ENOTSOCK=38,
    EDESTADDRREQ=39,
    EMSGSIZE=40,
    EPROTOTYPE=41,
    ENOPROTOOPT=42,
    EPROTONOSUPPORT=43,
    ESOCKTNOSUPPORT=44,
    ENOTSUP=45,
    EOPNOTSUPP=45,
    EPFNOSUPPORT=46,
    EAFNOSUPPORT=47,
    EADDRINUSE=48,
    EADDRNOTAVAIL=49,
    ENETDOWN=50,
    ENETUNREACH=51,
    ENETRESET=52,
    ECONNABORTED=53,
    ECONNRESET=54,
    ENOBUFS=55,
    EISCONN=56,
    ENOTCONN=57,
    ESHUTDOWN=58,
    ETOOMANYREFS=59,
    ETIMEDOUT=60,
    ECONNREFUSED=61,
    ELOOP=62,
    ENAMETOOLONG=63,
    EHOSTDOWN=64,
    EHOSTUNREACH=65,
    ENOTEMPTY=66,
    EPROCLIM=67,
    EUSERS=68,
    EDQUOT=69,
    ESTALE=70,
    EREMOTE=71,
    EBADRPC=72,
    ERPCMISMATCH=73,
    EPROGUNAVAIL=74,
    EPROGMISMATCH=75,
    EPROCUNAVAIL=76,
    ENOLCK=77,
    ENOSYS=78,
    EFTYPE=79,
    EAUTH=80,
    ENEEDAUTH=81,
    EPWROFF=82,
    EDEVERR=83,
    EOVERFLOW=84,
    EBADEXEC=85,
    EBADARCH=86,
    ESHLIBVERS=87,
    EBADMACHO=88,
    ECANCELED=89,
    EIDRM=90,
    ENOMSG=91,
    EILSEQ=92,
    ENOATTR=93,
    EBADMSG=94,
    EMULTIHOP=95,
    ENODATA=96,
    ENOLINK=97,
    ENOSR=98,
    ENOSTR=99,
    EPROTO=100,
    ETIME=101,
    EOPNOTSUPP=102,
    ENOPOLICY=103,
    ENOTRECOVERABLE=104,
    EOWNERDEAD=105,
    EQFULL=106,
    ELAST=106,
    ENOTSUP=156384713,
    EPROTONOSUPPORT=156384714,
    ENOBUFS=156384715,
    ENETDOWN=156384716,
    EADDRINUSE=156384717,
    EADDRNOTAVAIL=156384718,
    ECONNREFUSED=156384719,
    EINPROGRESS=156384720,
    ENOTSOCK=156384721,
    EMSGSIZE=156384722,
    EAFNOSUPPORT=156384723,
    ENETUNREACH=156384724,
    ECONNABORTED=156384725,
    ECONNRESET=156384726,
    ENOTCONN=156384727,
    ETIMEDOUT=156384728,
    EHOSTUNREACH=156384729,
    ENETRESET=156384730,
    EFSM=156384763,
    ENOCOMPATPROTO=156384764,
    ETERM=156384765,
    EMTHREAD=156384766,
    IO_THREADS=1,
    MAX_SOCKETS=2,
    SOCKET_LIMIT=3,
    THREAD_PRIORITY=3,
    THREAD_SCHED_POLICY=4,
    MAX_MSGSZ=5,
    MSG_T_SIZE=6,
    THREAD_AFFINITY_CPU_ADD=7,
    THREAD_AFFINITY_CPU_REMOVE=8,
    THREAD_NAME_PREFIX=9,
    IO_THREADS_DFLT=1,
    MAX_SOCKETS_DFLT=1023,
    THREAD_PRIORITY_DFLT=-1,
    THREAD_SCHED_POLICY_DFLT=-1,
    PAIR=0,
    PUB=1,
    SUB=2,
    REQ=3,
    REP=4,
    DEALER=5,
    ROUTER=6,
    PULL=7,
    PUSH=8,
    XPUB=9,
    XSUB=10,
    STREAM=11,
    AFFINITY=4,
    ROUTING_ID=5,
    SUBSCRIBE=6,
    UNSUBSCRIBE=7,
    RATE=8,
    RECOVERY_IVL=9,
    SNDBUF=11,
    RCVBUF=12,
    RCVMORE=13,
    FD=14,
    EVENTS=15,
    TYPE=16,
    LINGER=17,
    RECONNECT_IVL=18,
    BACKLOG=19,
    RECONNECT_IVL_MAX=21,
    MAXMSGSIZE=22,
    SNDHWM=23,
    RCVHWM=24,
    MULTICAST_HOPS=25,
    RCVTIMEO=27,
    SNDTIMEO=28,
    LAST_ENDPOINT=32,
    ROUTER_MANDATORY=33,
    TCP_KEEPALIVE=34,
    TCP_KEEPALIVE_CNT=35,
    TCP_KEEPALIVE_IDLE=36,
    TCP_KEEPALIVE_INTVL=37,
    IMMEDIATE=39,
    XPUB_VERBOSE=40,
    ROUTER_RAW=41,
    IPV6=42,
    MECHANISM=43,
    PLAIN_SERVER=44,
    PLAIN_USERNAME=45,
    PLAIN_PASSWORD=46,
    CURVE_SERVER=47,
    CURVE_PUBLICKEY=48,
    CURVE_SECRETKEY=49,
    CURVE_SERVERKEY=50,
    PROBE_ROUTER=51,
    REQ_CORRELATE=52,
    REQ_RELAXED=53,
    CONFLATE=54,
    ZAP_DOMAIN=55,
    ROUTER_HANDOVER=56,
    TOS=57,
    CONNECT_ROUTING_ID=61,
    GSSAPI_SERVER=62,
    GSSAPI_PRINCIPAL=63,
    GSSAPI_SERVICE_PRINCIPAL=64,
    GSSAPI_PLAINTEXT=65,
    HANDSHAKE_IVL=66,
    SOCKS_PROXY=68,
    XPUB_NODROP=69,
    BLOCKY=70,
    XPUB_MANUAL=71,
    XPUB_WELCOME_MSG=72,
    STREAM_NOTIFY=73,
    INVERT_MATCHING=74,
    HEARTBEAT_IVL=75,
    HEARTBEAT_TTL=76,
    HEARTBEAT_TIMEOUT=77,
    XPUB_VERBOSER=78,
    CONNECT_TIMEOUT=79,
    TCP_MAXRT=80,
    THREAD_SAFE=81,
    MULTICAST_MAXTPDU=84,
    VMCI_BUFFER_SIZE=85,
    VMCI_BUFFER_MIN_SIZE=86,
    VMCI_BUFFER_MAX_SIZE=87,
    VMCI_CONNECT_TIMEOUT=88,
    USE_FD=89,
    GSSAPI_PRINCIPAL_NAMETYPE=90,
    GSSAPI_SERVICE_PRINCIPAL_NAMETYPE=91,
    BINDTODEVICE=92,
    MORE=1,
    SHARED=3,
    DONTWAIT=1,
    SNDMORE=2,
    NULL=0,
    PLAIN=1,
    CURVE=2,
    GSSAPI=3,
    GROUP_MAX_LENGTH=255,
    EVENT_CONNECTED=0x0001,
    EVENT_CONNECT_DELAYED=0x0002,
    EVENT_CONNECT_RETRIED=0x0004,
    EVENT_LISTENING=0x0008,
    EVENT_BIND_FAILED=0x0010,
    EVENT_ACCEPTED=0x0020,
    EVENT_ACCEPT_FAILED=0x0040,
    EVENT_CLOSED=0x0080,
    EVENT_CLOSE_FAILED=0x0100,
    EVENT_DISCONNECTED=0x0200,
    EVENT_MONITOR_STOPPED=0x0400,
    EVENT_ALL=0xFFFF,
    EVENT_HANDSHAKE_FAILED_NO_DETAIL=0x0800,
    EVENT_HANDSHAKE_SUCCEEDED=0x1000,
    EVENT_HANDSHAKE_FAILED_PROTOCOL=0x2000,
    EVENT_HANDSHAKE_FAILED_AUTH=0x4000,
    PROTOCOL_ERROR_ZMTP_UNSPECIFIED=0x10000000,
    PROTOCOL_ERROR_ZMTP_UNEXPECTED_COMMAND=0x10000001,
    PROTOCOL_ERROR_ZMTP_INVALID_SEQUENCE=0x10000002,
    PROTOCOL_ERROR_ZMTP_KEY_EXCHANGE=0x10000003,
    PROTOCOL_ERROR_ZMTP_MALFORMED_COMMAND_UNSPECIFIED=0x10000011,
    PROTOCOL_ERROR_ZMTP_MALFORMED_COMMAND_MESSAGE=0x10000012,
    PROTOCOL_ERROR_ZMTP_MALFORMED_COMMAND_HELLO=0x10000013,
    PROTOCOL_ERROR_ZMTP_MALFORMED_COMMAND_INITIATE=0x10000014,
    PROTOCOL_ERROR_ZMTP_MALFORMED_COMMAND_ERROR=0x10000015,
    PROTOCOL_ERROR_ZMTP_MALFORMED_COMMAND_READY=0x10000016,
    PROTOCOL_ERROR_ZMTP_MALFORMED_COMMAND_WELCOME=0x10000017,
    PROTOCOL_ERROR_ZMTP_INVALID_METADATA=0x10000018,
    PROTOCOL_ERROR_ZMTP_CRYPTOGRAPHIC=0x11000001,
    PROTOCOL_ERROR_ZMTP_MECHANISM_MISMATCH=0x11000002,
    PROTOCOL_ERROR_ZAP_UNSPECIFIED=0x20000000,
    PROTOCOL_ERROR_ZAP_MALFORMED_REPLY=0x20000001,
    PROTOCOL_ERROR_ZAP_BAD_REQUEST_ID=0x20000002,
    PROTOCOL_ERROR_ZAP_BAD_VERSION=0x20000003,
    PROTOCOL_ERROR_ZAP_INVALID_STATUS_CODE=0x20000004,
    PROTOCOL_ERROR_ZAP_INVALID_METADATA=0x20000005,
    PROTOCOL_ERROR_WS_UNSPECIFIED=0x30000000,
    POLLIN=1,
    POLLOUT=2,
    POLLERR=4,
    POLLPRI=8,
    POLLITEMS_DFLT=16,
    HAS_CAPABILITIES=1,
    STREAMER=1,
    FORWARDER=2,
    QUEUE=3,
    SERVER=12,
    CLIENT=13,
    RADIO=14,
    DISH=15,
    GATHER=16,
    SCATTER=17,
    DGRAM=18,
    PEER=19,
    CHANNEL=20,
    ZAP_ENFORCE_DOMAIN=93,
    LOOPBACK_FASTPATH=94,
    METADATA=95,
    MULTICAST_LOOP=96,
    ROUTER_NOTIFY=97,
    XPUB_MANUAL_LAST_VALUE=98,
    SOCKS_USERNAME=99,
    SOCKS_PASSWORD=100,
    IN_BATCH_SIZE=101,
    OUT_BATCH_SIZE=102,
    WSS_KEY_PEM=103,
    WSS_CERT_PEM=104,
    WSS_TRUST_PEM=105,
    WSS_HOSTNAME=106,
    WSS_TRUST_SYSTEM=107,
    ONLY_FIRST_SUBSCRIBE=108,
    RECONNECT_STOP=109,
    HELLO_MSG=110,
    DISCONNECT_MSG=111,
    RECONNECT_STOP_CONN_REFUSED=0x1,
    RECONNECT_STOP_HANDSHAKE_FAILED=0x2,
    ZERO_COPY_RECV=10,
    NOTIFY_CONNECT=1,
    NOTIFY_DISCONNECT=2,
    EVENT_PIPES_STATS=0x10000,
    CURRENT_EVENT_VERSION=1,
    CURRENT_EVENT_VERSION_DRAFT=2,
    EVENT_ALL_V1=0xFFFF,
    EVENT_ALL_V2=0x1FFFF
}

function simZMQ.__init()
    if simZMQ.__const then
        for k,v in pairs(simZMQ.__const) do
            simZMQ[k]=v
            sim.registerScriptVariable('simZMQ.'..k..'@ZMQ')
        end
        simZMQ.__const=nil
    end

    -- wrap blocking functions with busy-wait loop:
    for func_name,flags_idx in pairs{msg_send=3,msg_recv=3,send=3,recv=2} do
        if not simZMQ['__'..func_name] then
            simZMQ['__'..func_name]=simZMQ[func_name]
            simZMQ[func_name]=function(...)
                local args={...}
                if sim.boolAnd32(args[flags_idx],simZMQ.DONTWAIT)>0 then
                    return simZMQ['__'..func_name](...)
                end
                args[flags_idx]=sim.boolOr32(args[flags_idx],simZMQ.DONTWAIT)
                while true do
                    local ret={simZMQ['__'..func_name](unpack(args))}
                    if ret[1]==-1 and simZMQ.errnum()==simZMQ.EAGAIN then
                        sim.switchThread()
                    else
                        return unpack(ret)
                    end
                end
            end
        end
    end

    simZMQ.__init=nil
end

__initFunctions=__initFunctions or {}
table.insert(__initFunctions,simZMQ.__init)

return simZMQ