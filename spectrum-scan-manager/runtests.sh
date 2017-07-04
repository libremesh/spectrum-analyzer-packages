#!/bin/bash
cd tests
for f in `ls`; do
    lua $f -v
done
