load'zeromq.ijs'
ctz=: zmq_ctx_new''
NB. need an "allocator" envelope to send the size/type of the array
allocator =: zmq_socket ctz;(socktype 'sub')
NB. subscriber is the data of interest; an array of some kind
subscriber =: zmq_socket ctz;(socktype 'sub')
zmq_connect allocator;'tcp://localhost:6666'
zmq_connect subscriber;'tcp://localhost:6666'
zmq_setsockopt allocator;(sockopt 'subscribe');'type'
zmq_setsockopt subscriber;(sockopt 'subscribe');'array'


testloop=: 3 : 0
 addr=:10#' '
 smbuff=. 32#' '
 while. 1 do.
  zmq_recv allocator;addr;(sockopt 'rcvbuf')
  zmq_recv allocator;smbuff;(sockopt 'rcvbuf')
  sk=. _3 ic smbuff
  giantbuff=. (0 pick sk) #' '
  zmq_recv subscriber;addr;(sockopt 'rcvbuf')
  zmq_recv subscriber;giantbuff;(sockopt 'rcvbuf')
  smoutput (":}.}.sk),' shape data received at ',": {:6!:0''
  smoutput (sk deserialize giantbuff)
end.
)


testloop''

zmq_close allocator
zmq_close subscriber
zmq_ctx_destroy ctz


NB. this implements the sub end of the simple pub-sub pattern
NB. useful for ad-hoc ticker plant types of things

