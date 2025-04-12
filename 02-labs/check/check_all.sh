#!/bin/sh
#TK28Dec2024
# sh check_all.sh
#
cargo build
for i in ../solutions/*.opt.sol
do
    NUM=`echo $i | grep -o '[0-9]\+'`
    target/debug/check_labs $NUM $i
done
