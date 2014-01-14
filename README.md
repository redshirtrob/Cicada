RJLisp
======

A scheme interpreter using Objective-C

Inspired by http://norvig.com/lispy.html, and aspiring to http://norvig.com/lispy2.html.

This is a pedagogical endeavor.  I doubt anyone will find this too useful.  I can say with certainty that no one will find it useful if I don't publish...so here it is.

Primtives
---------

RJLisp supports the primitives 'quote', 'if', 'set!', 'define', 'lambda', and 'begin' as part of eval.

Global Environment
------------------

RJLisp adds a number of useful functions to the global environment, including 'cons', 'car', 'cdr', 'list', 'null?', 'symbol?', 'eq?', and 'list?'.  You'll also find the basic arithmetic and inequality operatos.

Bugs
----

If you actually play around with this and find a bug, please let me know.  Either open an issue or send a pull request.
