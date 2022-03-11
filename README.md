# CLIgen (Command-Line Interface GENerator)
[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/clicon/cligen/CLIgen%20CI?label=CLIgen%20CI&style=for-the-badge)](https://github.com/clicon/cligen/actions/workflows/ci.yml)
[![GitHub Repo stars](https://img.shields.io/github/stars/clicon/cligen?style=for-the-badge)](https://github.com/clicon/cligen/stargazers)
[![GitHub issues](https://img.shields.io/github/issues/clicon/cligen?style=for-the-badge)](https://github.com/clicon/cligen/issues)
![Codecov](https://img.shields.io/codecov/c/gh/clicon/cligen?style=for-the-badge&token=6HXN51SARU)

CLIgen builds interactive, syntax-driven command-line interfaces (CLIs)
from a high-level syntax specification. Interactive CLIs are often used in
communication devices such as routers and switches. CLIgen is used to quickly
and easily build textual, syntax-driven command-based interfaces.

CLIgen accepts a high-level, interpreted syntax specification as input,
generates a tree representation of this provided syntax, and produces an interactive
command-line tool. Application semantics are written in the form of C callbacks.

## Basic Usage
A basic CLIgen specification file might look something like this:
```
prompt="hello> "
hello("Some command help text"){
    world("Some more command help text"), cb("Hello World!");
}
```
A CLI with the syntax above will present the user with one keyword `hello`. The user can
type a question mark to see a list of contextually acceptable keywords. For example, on the top-level,
only `hello` may be selected:
```
# ./cligen_hello
hello>
  hello                 Some command help text
```
However, at the second-level, only the keyword `world` may be selected:
```
# ./cligen_hello
hello> hello
  world                 Some more command help text
```
When a complete keyword sequence is entered, a registered callback function that
implements some application semantics is executed. CLIgen callbacks are written
in C and have the following signature:
```
int some_callback_function(cligen_handle h, cvec *cvv, cvec *argv);
```
In this example, the callback `cb` is called with the string `Hello World` as an argument. Arguments
can be accessed within the registered callback using the documented CLIgen API:
```
int cb(cligen_handle h, cvec *cvv, cvec *argv)
{
    printf("%s\n", cv_string_get(cvec_i(argv, 0)));
    return 0;
}
```
Here the function `cvec_i(argv, 0)` is used to access the first argument element as a pointer to a
CLIgen variable structure `cg_var`. Finally, this CLIgen variable pointer is passed to the CLIgen
variable string getter function `cv_string_get` which returns the type-appropriate value.
```
# ./cligen_hello
hello> hello world
Hello World!
```

## Documentation
The main documentation can be found in the [CLIgen Manual](cligen_manual.pdf).

Additional background material can be found on the [CLIgen project website](https://www.cligen.se).

## Clixon
CLIgen is _not_ a complete system. CLIgen is simply framework for quickly and easily building textual,
syntax-driven command-based interfaces.

Clixon is a complete YANG-based configuration manager that provides NETCONF, RESTCONF, and CLI interfaces.
Clixon incorporates an embedded transactional database that supports validation, commit, and revert semantics.

The Clixon CLI interface is provided by CLIgen.

[Clixon project website](https://www.clicon.org)

[Clixon GitHub](https://github.com/clicon/clixon)

## Building/Installing from Source

The source code here is built and installed using CMake:
```
  git clone https://github.com/clicon/cligen
  mkdir build && cd build
  cmake ../cligen
  cmake --build .
  cmake --install .
```

Several CLIgen-specific build options are available:
* `-DCLIGEN_MAINTAINER_MODE` Forces debug builds and verbose Makefile output.
* `-DCLIGEN_STATIC` Builds a static library.
* `-DCLIGEN_WITH_APPS` Builds the example applications linked according to `CLIGEN_STATIC`.
* `-DCLIGEN_WITH_LIBXML2` Build using the GNOME\LibXML2 regex engine.

The source builds a single library. If you build applications, you should include `cligen.h` and link with the library `libcligen`.

There are several example applications:
* `apps/cligen_hello` Simplest possible. Just builds a 'hello world' greeting by in-line C.
* `apps/cligen_file` Read a syntax specification from file. You must supply the file.
* `apps/cligen_tutorial` Samples of techniques used in the [CLIgen Manual](cligen_tutorial.pdf).

See also [Changelog](CHANGELOG.md).

## License
CLIgen is dual licensed either under the Apache License, Version 2.0 or the GNU
General Public License Version 2.

## Contact
I can be found at olof@hagsand.se.

## Third Party Acknowledgements 
### getline
Copyright (C) 1991, 1992, 1993 by Chris Thewalt (thewalt@ce.berkeley.edu)

Permission to use, copy, modify, and distribute this software 
for any purpose and without fee is hereby granted, provided
that the above copyright notices appear in all copies and that both the
copyright notice and this permission notice appear in supporting
documentation.  This software is provided "as is" without express or
implied warranty.
