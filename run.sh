#!/bin/bash
export COB_PRE_LOAD=/home/rroland/src/gnucobol-dev/extras/CBL_OC_DUMP.so:/usr/lib/x86_64-linux-gnu/libfcgi.so:/usr/local/lib/libocsql.so

out/simple.fcgi $*
