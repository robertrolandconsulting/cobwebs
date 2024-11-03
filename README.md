# books

Learning COBOL by making an app to track my books.

## Setting up

Getting unixODBC working right with PostgreSQL was not straightforward.

On EndeavorOS / Arch Linux:

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

## LICENSE

MIT license.