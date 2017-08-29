#!/bin/bash
for f in `ls tests`; do
    lua tests/$f -v
done
