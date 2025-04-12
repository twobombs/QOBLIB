BEGIN {
   row = 1;
}

/^\s*#/ {
    next;
}

NF > 2 {
    for(i = 1; i < NF; i++) {
        print row, i, $i;
    }
    print row, 0, $NF;

    row++;
}
