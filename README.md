# CobWebs

A COBOL web framework.

## Building

Built on GnuCOBOL 3.2. This uses FastCGI and the FFI that GnuCOBOL offers,
so it may not work on other COBOL compilers.

### Dependencies

On Fedora Linux:

```bash
sudo dnf install gnucobol fcgi
```

On Debian / Ubuntu:

```bash
sudo apt install libfcgi-dev gnucobol3
```

## LICENSE

MIT license.
