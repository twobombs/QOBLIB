#!/bin/sh
#TK27Dec2024
# sh check_all.sh
#
cargo build --release 

PASSED=0
FAILED=0

for i in ../solutions/*.opt.sol
do
    NAME=`basename $i .opt.sol`
    echo Checking $NAME...

    OUTPUT=$(target/release/check_marketsplit ../instances/$NAME.dat $i)
    echo OUTPUT: $OUTPUT
    if echo "$OUTPUT" | tail -n 1 | grep -q "successful"; then
        PASSED=$((PASSED+1))
    else
        echo "Test $NAME failed"
        FAILED=$((FAILED+1))
    fi
done

echo "Passed $PASSED out of $((PASSED + FAILED)) tests"
