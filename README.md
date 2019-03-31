# MyHTML

MyHTML is a Swift warper for the [MyHTML C library](https://github.com/lexborisov/myhtml), a fast, pure C, HTML 5 parser.

## Status
Most non-mutating high level parsing functions are already warped, in other words you should already be able to *read* the DOM tree with the current state of the project. Contributions, in the form of issues or PRs are welcome, don't hesitate to contact me if you have any requests or suggestions.

**This library has continuous integration**, the master branch is protected and the master **branch tip** should always pass tests.

### Master branch
[![CircleCI](https://circleci.com/gh/adtrevor/MyHTML/tree/master.svg?style=svg&circle-token=3808acb78aad3d4ac2be1cca928ca498b2447673)](https://circleci.com/gh/adtrevor/MyHTML/tree/master)

### Dev branch
[![CircleCI](https://circleci.com/gh/adtrevor/MyHTML/tree/dev.svg?style=svg&circle-token=3808acb78aad3d4ac2be1cca928ca498b2447673)](https://circleci.com/gh/adtrevor/MyHTML/tree/dev)

## Installation
### macOS
To install the MyHTML C library on your machine, cloning the [MyHTML **C repo**](https://github.com/lexborisov/myhtml) and following [the install instructions](https://github.com/lexborisov/myhtml/blob/master/INSTALL.md) should be enough.

### Linux
Installing on Linux is nearly as easy as on macOS, start by cloning the [MyHTML **C repo**](https://github.com/lexborisov/myhtml). Since the Linux linker doesn't search for shared libraries in `/usr/local`, which is the default install location, my best recommendation is to specify a different install prefix.
From the root of your **MyHTML *C library* source clone**, run:
```bash
make prefix="/usr"
make test
make install prefix="/usr"
```

### Additional installation notes
- Once you followed the install instructions, you can use this library as any other Swift Package Manager library, just don't forget to include the correct flags if you are using Xcode, as described in the *Installation > macOS* section of this document.
- Additional installation details and options are documented in the [C project install instructions](https://github.com/lexborisov/myhtml/blob/master/INSTALL.md)

## License notes
This Swift warper is distributed under the *Apache License 2.0*, note that this license only concerns the Swift warper. The [MyHTML C library](https://github.com/lexborisov/myhtml) is distributed under it's own license.
