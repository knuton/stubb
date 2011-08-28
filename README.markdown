Second Mate
===========

Specify REST API stubs using your file system.

Directory Structure
-------------------

Directory structure determines API resources.

HTTP Verbs
----------

Collections: collection/GET.format
Members: collection/member.GET.format

Sequences
---------

A sequence in Second Mate is a sequence of response files whose members are being used as sources for a sequence of requests. This allows stubbing change in the API occuring over time.

### Stalling sequences
  1..._n_
  [GET.1.format, GET.2.format, ..., GET._n-1_.format, GET._n_.format]

Stalling sequences respond with response file _n_ after a sequence of _n_ requests. Thus the same response keeps being given, i.e. the sequence's tail.

### Looping sequences
  0..._n-1_
  [GET.0.format, GET.1.format, ..., GET._n-2_.format, GET._n-1_.format]

Looping sequences start cycling through the responses after the sequences tail has been responded with.
