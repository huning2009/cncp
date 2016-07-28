Complex networks, complex processes
===================================

This is the source repository for my book "Complex networks,
complex proceses". As the title suggests, it is about the construction
and analysis of complex networks and the processes that run over
them. It is intended to sit on the boundary between mathematics and
computer science and to help get new researchers up to speed with the
ideas and technologies.


Reading the book
----------------

If you just want to read the book, it can be found here:

http://www.simondobson.org/complex-networks-complex-processes/

At present the book is very much a work in progress, but I'd be
delighted to receive any comments from anyone who's interested in
these areas and ideas.


Building and accessing the book
-------------------------------

The book has a complicated, make-based build system that will create
HTML and PDF copies from the same set of IPython notebooks. You can
access the book by typing "make live". This creates a Python virtual
environment ("virtualenv") that's known to work, and opens a browser
window onto the distribution. Clicking on
"complex-networks-complex-processes.ipynb" will open the contents page.

You can generate different formats of the book with "make www" or
"make pdf".

There are lots of other things the build system can do. Try "make" or
"make help" for more information. 


Building virtual machines
-------------------------

A somewhat experimental feature at present is the ability to build
virtual machines: a compute server for conducting experiments, and
an interactive VM that's capable of building the book itself. The
vm/ directory has the details. 


Simon Dobson

St Andrews, UK. 27 July 2016.
