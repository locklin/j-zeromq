NB. zeromq hooks for J.
NB. the function calls are identical to those in C.
NB. 
NB. I'm envisioning this being used in a protected namespace to keep the
NB. end user from being confronted with raw pointers and allocating buffers
NB. possible use cases: multithreaded J tasks via push/pull, a better 
NB. client/server for J or JDB via request/reply, a pub/sub ticker plant, etc
NB. I might code up the JDB thing, as JDB is generally useful
NB. 
NB. I've also included a couple of helper functions
NB. two of them are copies of the zmq.h options (lowercase, zmq_ stripped) 
NB. sockopt 'option' returns the socket option; use it with zmq_setsockopt
NB. zmq_setsockopt socket;(sockopt 'subscribe');channel
NB.  
NB. socktype 'type' returns the  socket type; use it with zmq_socket
NB. zmq_socket contextptr;(socktype 'sub')
NB. 
NB. Helper functions for passing J structures and arrays around 
NB. TBD, if needed
NB. struct buffer allocator? 
NB. most of the details of sending things via zeromq is best done within zmq


NB. thanks to Pascal for pointing these out
NB. 3!:3 works also
serialize=: 3 : 0
 3 (3!:1) y
)

deserialize=: 3 : 0
 3!:2 y
)


NB. actual ZeroMQ hooks below

3 : 0''
if. UNAME-:'Linux' do.
  ZMQ=: jpath'/usr/local/lib/libzmq.so'
elseif. UNAME-:'Darwin' do.  NB. I dunno where darwin keeps things any more
  ZMQ=: '"',~'"',jpath '~addons/net/zeromq/libzmq.dylib'
elseif. do.
  ZMQ=: '"',~'"',jpath '~addons/net/zeromq/libzmq.so', (IF64#'_64'), '.dll'
end.
)




cd=: 15!:0

NB. void *zmq_ctx_new (void);
zmq_ctx_new =: 3 : 0
 cmd=. ZMQ,' zmq_ctx_new * '
 0 pick cmd cd ''
)

NB. int zmq_ctx_set (void *context, int option, int optval);
zmq_ctx_set =: 3 : 0
 'ctx option optval'=. y
 cmd=. ZMQ,' zmq_ctx_set i i i i'
 0 pick cmd cd ctx;option;optval
)

NB. int zmq_ctx_get (void *context, int option);
zmq_ctx_get=: 3 : 0
 'ctx option'=.y
 cmd=. ZMQ,' zmq_ctx_get i i i'
 0 pick cmd cd ctx;option
)

NB. int zmq_ctx_destroy (void *context);
zmq_ctx_destroy =: 3 : 0
 'ctx'=.y
 cmd=. ZMQ,' zmq_ctx_destroy i i'
 0 pick cmd cd ctx
)


NB. void *zmq_socket (void *, int type);
zmq_socket =: 3 : 0
 'ctx type'=.y
 cmd=. ZMQ,' zmq_socket * i i'
 0 pick cmd cd ctx;type
)

NB. int zmq_bind (void *s, const char *addr);
zmq_bind =: 3 : 0
 'sock addr'=.y
 cmd =. ZMQ,' zmq_bind i i *c'
 0 pick cmd cd sock;addr
)

NB. zmq_connect (subscriber, "tcp://localhost:5563");
NB. ZMQ_EXPORT int zmq_connect (void *s, const char *addr);
zmq_connect=: 3 : 0
 'sock addr' =. y
 cmd=. ZMQ,' zmq_connect i i *c'
 0 pick cmd cd sock;addr
)

NB.  int zmq_setsockopt (void *s, int option, const void *optval, size_t optvallen); 
NB. only one optval set at a time, must be multicharacter
zmq_setsockopt=: 3 : 0
 'sock kind optval' =. y
 cmd=. ZMQ,' zmq_setsockopt i i i *c i'
 0 pick cmd cd sock;kind;optval;1
)

NB. int zmq_getsockopt (void *s, int option, void *optval, size_t *optvallen);
zmq_getsockopt=: 3 : 0
 'sock kind optval len' =. y
 cmd=. ZMQ,' zmq_getsockopt i i i *c i'
 0 pick cmd cd sock;kind;optval;len
)


NB. int zmq_recv (void *s, void *buf, size_t len, int flags);
zmq_recv =: 3 : 0
 'sock buff flag'=.y	
 size=. 7!:5 < 'buff' 
 cmd=. ZMQ,' zmq_recv i i * i i'
 2 pick cmd cd sock;buff;size;flag
)

NB. int zmq_send (void *s, const void *buf, size_t len, int flags);
zmq_send =: 3 : 0
 'sock buff flag'=.y	
 size=. 7!:5 < 'buff' 
 cmd=. ZMQ,' zmq_send i i * i i'
 0 pick cmd cd sock;buff;size;flag
)

NB. int zmq_close (void *s);
zmq_close =: 3 : 0
 'sock'=.y
 cmd=. ZMQ,' zmq_close i i'
 0 pick cmd cd sock
)


NB. /*  Socket types.                                                             */ 
NB. #define ZMQ_PAIR 0
NB. #define ZMQ_PUB 1
NB. #define ZMQ_SUB 2
NB. #define ZMQ_REQ 3
NB. #define ZMQ_REP 4
NB. #define ZMQ_DEALER 5
NB. #define ZMQ_ROUTER 6
NB. #define ZMQ_PULL 7
NB. #define ZMQ_PUSH 8
NB. #define ZMQ_XPUB 9
NB. #define ZMQ_XSUB 10
NB. SOCKTYPES=: ;/ i.11
SOCKNAMES=: 'pair';'pub';'sub';'req';'rep';'dealer';'router';'pull';'push';'xpub';'xsub'

socktype =: 3 : 0
 key =. < y
 SOCKNAMES i. key
)

NB. /*  Socket options.                                                           */
NB. #define ZMQ_AFFINITY 4
NB. #define ZMQ_IDENTITY 5
NB. #define ZMQ_SUBSCRIBE 6
NB. #define ZMQ_UNSUBSCRIBE 7
NB. #define ZMQ_RATE 8
NB. #define ZMQ_RECOVERY_IVL 9
NB. #define ZMQ_SNDBUF 11
NB. #define ZMQ_RCVBUF 12
NB. #define ZMQ_RCVMORE 13
NB. #define ZMQ_FD 14
NB. #define ZMQ_EVENTS 15
NB. #define ZMQ_TYPE 16
NB. #define ZMQ_LINGER 17
NB. #define ZMQ_RECONNECT_IVL 18
NB. #define ZMQ_BACKLOG 19
NB. #define ZMQ_RECONNECT_IVL_MAX 21
NB. #define ZMQ_MAXMSGSIZE 22
NB. #define ZMQ_SNDHWM 23
NB. #define ZMQ_RCVHWM 24
NB. #define ZMQ_MULTICAST_HOPS 25
NB. #define ZMQ_RCVTIMEO 27
NB. #define ZMQ_SNDTIMEO 28
NB. #define ZMQ_IPV4ONLY 31
NB. #define ZMQ_LAST_ENDPOINT 32
NB. #define ZMQ_ROUTER_MANDATORY 33
NB. #define ZMQ_TCP_KEEPALIVE 34
NB. #define ZMQ_TCP_KEEPALIVE_CNT 35
NB. #define ZMQ_TCP_KEEPALIVE_IDLE 36
NB. #define ZMQ_TCP_KEEPALIVE_INTVL 37
NB. #define ZMQ_TCP_ACCEPT_FILTER 38
NB. #define ZMQ_DELAY_ATTACH_ON_CONNECT 39
NB. #define ZMQ_XPUB_VERBOSE 40
SOCKOPTS=: 1;2;4;5;6;7;8;9;11;12;13;14;15;16;17;18;19;21;22;23;24;25;27;28;31;32;33;34;35;36;37;38;39;40
SOCKOPTNAMES=:'dontwait';'sndmore';'affinity';'identity';'subscribe';'unsubscribe';'rate';'recovery_ivl';'sndbuf';'rcvbuf';'rcvmore';'fd';'events';'type';'linger';'reconnect_ivl';'backlog';'reconnect_ivl_max';'maxmsgsize';'sndhwm';'rcvhwm';'multicast_hops';'rcvtimeo';'sndtimeo';'ipv4only';'last_endpoint';'router_mandatory';'tcp_keepalive';'tcp_keepalive_cnt';'tcp_keepalive_idle';'tcp_keepalive_intvl';'tcp_accept_filter';'delay_attach_on_connect';'xpub_verbose'

sockopt=: 3 : 0
 key =. < y
 > (SOCKOPTNAMES i. key) { SOCKOPTS
)


NB. do these some other time...
NB. /*  Message options                                                           */
NB. #define ZMQ_MORE 1

NB. /*  Send/recv options.                                                        */
NB. #define ZMQ_DONTWAIT 1
NB. #define ZMQ_SNDMORE 2

NB. /*  Socket transport events (tcp and ipc only)                                */
NB. #define ZMQ_EVENT_CONNECTED 1
NB. #define ZMQ_EVENT_CONNECT_DELAYED 2
NB. #define ZMQ_EVENT_CONNECT_RETRIED 4

NB. #define ZMQ_EVENT_LISTENING 8
NB. #define ZMQ_EVENT_BIND_FAILED 16

NB. #define ZMQ_EVENT_ACCEPTED 32
NB. #define ZMQ_EVENT_ACCEPT_FAILED 64

NB. #define ZMQ_EVENT_CLOSED 128
NB. #define ZMQ_EVENT_CLOSE_FAILED 256
NB. #define ZMQ_EVENT_DISCONNECTED 512
