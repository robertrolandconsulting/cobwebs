# books

Learning COBOL by making an app to track my books.

## Setting up

Getting unixODBC working right with PostgreSQL was not straightforward.

### EndeavorOS / Arch Linux

```bash
# install the driver
pacman -Sy unixodbc psqlodbc

# fix an issue where /etc/odbc.ini starts out empty,
# which causes an error installing the driver
cat <<EOF | sudo tee -a /etc/odbc.ini
[empty-sys]
EOF

# create a template file for driver installation
cat <<EOF >template.ini
[PostgreSQL]
Description = PostgreSQL driver for GNU/Linux
Driver      = /usr/lib/psqlodbcw.so
Setup       = /usr/lib/psqlodbcw.so
EOF

# actually install the driver
sudo odbcinst -i -d -f template.ini
```

### AIX 7.2

Yes, AIX. GCC in the AIX Toolkit likes to generate 32-bit binaries by default,
but we need 64 bit binaries so we can link everything - that's why there are
special `CFLAGS` and `LDFLAGS` and such below.

Grab all of these dependencies:

```bash
bash# /opt/freeware/bin/dnf install -y automake autoconf m4 gcc gcc-c++ \
    unixODBC-devel libtool db-devel json-c-devel libxml2-devel gmp-devel \
    ncurses-devel postgresql15-server postgresql15-devel wget
```

Download the GnuCOBOL 3.2 sources from the [official site](https://gnucobol.sourceforge.io/) and
extract them.

```bash
cd ~/src/gnucobol-3.2
CFLAGS='-maix64' LDFLAGS='-Wl,-b64 -maix64' ./configure
make
su
make install
```

Now, grab the GnuCOBOL contribs package, where embedded SQL preprocessor is:

```bash
cd ~/src
git clone https://github.com/OCamlPro/gnucobol-contrib.git
cd gnucobol-contrib/esql
./autogen.sh
CXX=g++ CFLAGS='-maix64' CXXFLAGS='-maix64' LDFLAGS='-Wl,-b64 -maix64' ./configure --enable-shared
make
su
make install
```

Next, grab and compile the psqlodbc driver:

```bash
cd ~/src
git clone https://github.com/postgresql-interfaces/psqlodbc.git
cd psqlodbc
./bootstrap
CFLAGS='-maix64' LDFLAGS='-Wl,-b64 -maix64' OBJECT_MODE=64 ./configure
OBJECT_MODE=64 make
su
make install
mkdir -p /usr/local/lib64
cp .libs/*.so /usr/local/lib64
```

I have no idea why it didn't include these .so files during `make install` but so be it.

Configure unixODBC, similar to above but slightly different:

```bash
# create a template file for driver installation
cat <<EOF >template.ini
[PostgreSQL]
Description = PostgreSQL driver for GNU/Linux
Driver      = /usr/local/lib64/psqlodbcw.so
Setup       = /usr/local/lib64/psqlodbcw.so
EOF

# actually install the driver
su
/opt/freeware/bin/odbcinst -i -d -f template.ini
```

## LICENSE

MIT license.