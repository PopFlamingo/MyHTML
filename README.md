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
To install the MyHTML C library on your machine, cloning the [MyHTML C repo](https://github.com/lexborisov/myhtml) and following [the install instructions](https://github.com/lexborisov/myhtml/blob/master/INSTALL.md) should be enough.

When using the MyHTML Swift warper library, if you are generating an Xcode project with Swift Package Manager, you must curently specify the `-Xcc -I/usr/local/include` and `-Xswiftc -I/usr/local/include` for *the Xcode project* to build, like this:
```bash
swift package -Xcc -I/usr/local/include -Xswiftc -I/usr/local/include generate-xcodeproj
```
**Note that this is only required for Xcode, you shouldn't need to specify additional flags for anything else.**

### Linux
Installing on Linux is nearly as easy as on macOS, start by cloning the [MyHTML C repo](https://github.com/lexborisov/myhtml). Since the Linux linker doesn't search for shared libraries in `/usr/local`, which is the default install location, my best recommendation is to specify a different install prefix.
From the root of your **MyHTML C library source clone**, run:
```bash
make prefix="/usr"
make test
make install prefix="/usr"
```

### Notes
*Additional installation details are available in the [C project install instructions](https://github.com/lexborisov/myhtml/blob/master/INSTALL.md)*.
