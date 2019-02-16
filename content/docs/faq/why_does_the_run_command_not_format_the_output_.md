---
title: Why does the run command not format the output?
---

The run command - called in array context - will return an array.

If you want to print the output to your terminal you have to call it in a scalar context.

    my $output = run "df -h";
    say $output;
