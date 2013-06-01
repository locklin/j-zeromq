NB. demo ticker plant, sending random numbers of rows of data.
load'zeromq.ijs'
ctx=: zmq_ctx_new''
publisher =: zmq_socket ctx;(socktype 'pub')
zmq_bind publisher;'tcp://*:6666'



tickerplant=: 3 : 0
while. 1 do. 
 goodmsg=. ((?100), 10) $ (? 1 2 3) NB.  10 100 $ i.1000 NB. ((1 ? 100),10) $ i.11
 envelope=. arraykind goodmsg NB. type, dimensions
 zmq_send publisher;'type';2
 zmq_send publisher; (serialize envelope);0
 zmq_send publisher;'array';2
 zmq_send publisher; (serialize goodmsg);0
 6!:3 (1.5)
 smoutput 'sent messages'
end.
zmq_close publisher
zmq_ctx_destroy ctx
)

tickerplant''