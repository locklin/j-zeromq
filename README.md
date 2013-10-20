This is (partially) tested against zeromq 4.0.1 (it also works with 3.x). 
I'm assuming it will work on subsequent versions; the FFI is trivial enough 
to keep it up to date.
Since most versions of Linux do not presently have the latest ZMQ installed, 
I have it look in
/usr/local/lib

zeromq can be found here:
http://www.zeromq.org/

I have tested it against the pub-sub/envelope pattern. One "gotcha" is it 
requires envelope labels to be more than one character long.

The Right Way to use this is to pull it into a namespace to protect the user 
from raw pointers.

I added a fake "ticker plant" consisting of sending random boxed floats and
ints  through a pub-sub pattern.

ToDo: 1) add a few doodads from CZMQ
          2) a few more examples