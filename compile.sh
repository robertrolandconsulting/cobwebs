#!/bin/bash
pushd out
cobc -I../temp/ -x ../temp/simple.cbl ../temp/fcgi.cbl -o simple.fcgi -A '-include fcgi_config.h' -A '-include fcgiapp.h' -lfcgi --debug -g
popd
