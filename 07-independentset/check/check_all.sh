#!/bin/sh
#TK27Dec2024
# sh check_all.sh
#
cargo build
for i in ../solutions/*.sol
do
    TNAM=`basename $i .sol`
    NAME=`basename $TNAM .opt`
    target/debug/check_stableset ../instances/$NAME.gph $i
done
