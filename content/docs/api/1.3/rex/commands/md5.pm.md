---
title: MD5.pm
---

-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [SYNOPSIS](#SYNOPSIS)
-   [EXPORTED FUNCTIONS](#EXPORTED-FUNCTIONS)
    -   [md5($file)](#md5-file-)

# NAME

Rex::Commands::MD5 - Calculate MD5 sum of files

# DESCRIPTION

With this module you calculate the md5 sum of a file.

This is just a helper function and will not be reported.

# SYNOPSIS

     my $md5 = md5($file);

# EXPORTED FUNCTIONS

## md5($file)

This function will return the MD5 checksum (hexadecimal) for the given file.

     task "md5", "server01", sub {
       my $md5 = md5("/etc/passwd");
     };
