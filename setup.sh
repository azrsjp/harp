#!/bin/sh

cd `dirname $0`

# clone alure
git submodule update --init --recursive

# make working dir
mkdir temp

# make and install alure1.2
cd temp
cmake ../external/alure
make
make install
cd ../

# clean
rm -rf temp
