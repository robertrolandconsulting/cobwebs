#!/bin/bash
export COB_PRE_LOAD=/usr/lib/x86_64-linux-gnu/libfcgi.so:/usr/local/lib/libocsql.so

/home/rroland/src/cobwebs/out/cobwebs.fcgi $*
