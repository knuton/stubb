Second Mate
===========

Second Mate allows to **set up a REST API stub by putting responses in files** ordered into a directory tree. Resource names, HTTP verbs and response types are **all specified in file names**.

Additionally, Second Mate allows to specify **sequences of responses** to mock development over time.

Stubb is the second mate.

Directory Structure and Response Files
--------------------------------------

Directory structure determines API resources.

HTTP Verbs
----------

Collections: `collection/GET.format`  
Members: `collection/member.GET.format`

Sequences
---------

A sequence in Second Mate is a sequence of response files whose members are being used as sources for a sequence of requests. This allows stubbing change in the API occuring over time.

### Stalling sequences (1..._n_)

    GET.1.format, GET.2.format, ..., GET._n-1_.format, GET._n_.format

Stalling sequences respond with response file _n_ after a sequence of _n_ requests. Thus the same response keeps being given, i.e. the sequence's tail.

### Looping sequences (0..._n-1_)

    GET.0.format, GET.1.format, ..., GET._n-2_.format, GET._n-1_.format

Looping sequences start cycling through the responses after the sequences tail has been responded with.

Parameter Insertion
-------------------

To allow some amount of dynamicity, Second Mate parses response files as ERB templates and makes GET and POST parameters available in a `params` hash. This can come in handy when stubbing POST and PUT requests or serving JSONP requests.

Dependencies
------------

Second Mate depends on

  - <a href="http://github.com/rack/rack">Rack</a> for processing and serving requests, and
  - <a href="https://github.com/wycats/thor">Thor</a> for adding a CLI executable.

License
-------

Copyright (c) 2011 Johannes Emerich

MIT-style licensing, for details see file `LICENSE`.

<hr>

_'Why,' thinks I, 'what's the row? It's not a real leg, only a false leg.'_  
--Stubb in _Moby Dick_
