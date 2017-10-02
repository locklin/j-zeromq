NB. demo ticker plant, sending random numbers of rows of data.
load jpath,'~/src/jstuff/j-zeromq/zeromq.ijs'
ctx=: zmq_ctx_new''
publisher =: zmq_socket ctx;(socktype 'pub')
zmq_bind publisher;'tcp://*:6666'




floatrand=: ?@$ % ] - 1:

tickerplant=: 3 : 0
while. 1 do. 
 goodmsg=. (10 2 $ 20 floatrand 10) ;((?100), 10) $ (? 1 2 3) NB. boxed message
 serialized=. serialize goodmsg                          NB. this is just 3!:1
 env =. <.(7!:5 < 'serialized')                            NB. note 7!:5 returns a float
 zmq_send publisher;'type';(sockopt 'sndmore') NB. message header
 zmq_send publisher; (3 ic env);0                    NB. buffer size message
 zmq_send publisher;'array';(sockopt 'sndmore') NB. message header
 zmq_send publisher; serialized ;0                     NB. send buffer
 6!:3 (1.5)                                                         NB. pause 1.5 sec
 smoutput 'sent message of ', (": env), ' bytes'  NB. talk about what was sent
end.
zmq_close publisher                                          NB. cleanup
zmq_ctx_destroy ctx
)

tickerplant''

