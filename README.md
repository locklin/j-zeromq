This is (partially) tested against zeromq 3.2.2. I'm assuming it will work on 
subsequent versions; anyway the FFI is trivial enough to keep it up to date.
Since most versions of Linux do not presently have the latest ZMQ installed, I have 
it look in
/usr/local/lib

zeromq can be found here:
http://www.zeromq.org/

I have tested it against the pub-sub/envelope pattern. One "gotcha" is it requires 
envelope labels to be more than one character long.

The Right Way to use this is to pull it into a namespace to protect the user from raw pointers.
I'll eventually include a couple of examples.

