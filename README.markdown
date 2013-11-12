![Stubb](https://github.com/knuton/stubb/raw/master/stubb.png)

Stubb is a testing and development tool for frontend developers and anyone else depending on HTTP-requesting resources for their work. It allows **setting up a REST API stub by putting responses in files** organized in a directory tree. Which file is picked in response to a particular HTTP request is primarily determined by the request's **method**, **path** and **accept header**. Thus adding a response for a certain type of request is as easy as adding a file with a matching name. For example, the file

    whales/narwhal.GET.json

in your base directory will be picked to deliver the response to the request

    GET /whales/narwhal.json HTTP/1.1

or alternatively

    GET /whales/narwhal HTTP/1.1
    Accept: application/json

.

Additionally, **sequences of responses** to repeated identical requests can be defined through infix numerals in file names.

Getting Started
---------------

Simply install the Stubb gem by running

    gem install stubb

and you are ready to run the stubb CLI:

    $ stubb
    Tasks:
      stubb help [TASK]  # Describe available tasks or one specific task
      stubb server       # Starts the server
      stubb version      # Print the version of Stubb

    $ echo Ahoy > hello-world.GET
    $ ls
    hello-world.GET
    $ stubb server &
    $ curl http://localhost:4040/hello-world
    Ahoy

By default the server runs on port 4040 and looks for response files in the working directory. Run `stubb help server` for information on configuration options.

Directory Structure and Response Files
--------------------------------------

All requests are served from the *base directory*, that is the directory Stubb was started from. The directory tree in your base directory determines the path hierarchy of your stubbed REST API. Request paths are mapped to relative paths within the base directory to locate a response file.

### Response Files

A *response file* is a file containing an API response. There are two kinds of response files, member response files and collection response files. They differ only in concept and naming.

#### Member Response Files

A *member response file* is a file containing an API response for a member resource, named after the scheme

    REQUEST_PATH_WITHOUT_EXTENSION.HTTP_METHOD[.SEQUENCE_NUMBER][.FILE_TYPE]

, where `SEQUENCE_NUMBER` is optional and only needed when defining response sequences, and `FILE_TYPE` is also optional and only needed when a file type is implied by request path or accept header.

Examples:

    whales/narwhal.GET
    whales/narwhal.GET.json
    whales/narwhal.GET.1
    whales/narwhal.GET.1.json

#### Collection Response Files

A *collection response file* is a file containing an API response for a collection resource, named after the scheme

    REQUEST_PATH_WITHOUT_EXTENSION/HTTP_METHOD[.SEQUENCE_NUMBER][.FILE_TYPE]

, where `SEQUENCE_NUMBER` is optional and only needed when defining response sequences, and `FILE_TYPE` is also optional and only needed when a file type is implied by request path or accept header.

Examples:

    whales/GET
    whales/GET.json
    whales/GET.1
    whales/GET.1.json

### Response Files as ERB Templates

Any matching response file will be evaluated as an ERB template, with `GET` or `POST` parameters available in a `params` hash. This can come in handy when stubbing `POST` and `PUT` requests or serving JSONP.

### YAML Frontmatter

Response files may contain YAML frontmatter before the response text, allowing to set custom values for response status and header:

    ---
    status: 201
    header:
      Cache-Control: no-cache
    ---
    {"name":"Stubb"}

### Missing Responses

If no matching response file is found, Stubb replies with a status of `404`. You can customize error responses for types of requests by creating a matching response file that contains your custom response.

Path Matching
-------------

Paths in the base directory may include wildcards to allow one response file to match for a whole range of request paths instead of just one. Both Directory names and file names may be wildcards. Wildcards are marked by starting and ending in an underscore (`_`). A wildcard segment matches any equally positioned segment of a request path.

For example

    whales/_default_whale_.GET.json

matches

    GET /whales/pygmy_sperm_whale.json HTTP/1.1

as well as

    GET /whales/blackfish.json HTTP/1.1

.

If a literal match exists, it will be chosen over a wildcard match.

Response Sequences
------------------

A *response sequence* is a sequence of response files whose members are being used as responses to a sequence of requests of the same type. This allows for controlled stubbing of changes in the API.

### Stalling Sequences (1..._n_)

A *stalling sequence* keeps responding with the last response file in the response sequence after _n_ requests of the same type. Stalling sequences are specified by adding response files with indices 1 through _n_.

    GET.1.format, GET.2.format, ..., GET._n-1_.format, GET._n_.format

Example:

    whales/GET.1.json
    whales/GET.2.json
    whales/GET.3.json

From the third request on, the response to

    GET /whales.json HTTP/1.1

will be the one given in `whales/GET.3.json`.

### Looping Sequences (0..._n-1_)

A *looping sequence* starts from the first response file in the response sequence after _n_ requests of the same type. Looping sequences are specified by adding response files with indices 0 through _n_-1.

    GET.0.format, GET.1.format, ..., GET._n-2_.format, GET._n-1_.format

Example:

    whales/GET.0.json
    whales/GET.1.json
    whales/GET.2.json

The response to the fourth request to

    GET /whales.json HTTP/1.1

will again be the one given in `whales/GET.0.json`, and so forth.

Dependencies
------------

Stubb depends on

  - <a href="http://github.com/rack/rack">Rack</a> for processing and serving requests, and
  - <a href="https://github.com/wycats/thor">Thor</a> for adding a CLI executable.

Acknowledgements
----------------

The logo for Stubb was kindly provided by Andres Colmenares of [Wawawiwa](https://www.facebook.com/pages/Wawawiwa-design/201009879921770).

License
-------

Copyright (c) 2011 Johannes Emerich

MIT-style licensing, for details see file `LICENSE`.

<hr>

[![Build Status](https://travis-ci.org/knuton/stubb.png?branch=master)](https://travis-ci.org/knuton/stubb)

_'Why,' thinks I, 'what's the row? It's not a real leg, only a false leg.'_  
--Stubb in _Moby Dick_
