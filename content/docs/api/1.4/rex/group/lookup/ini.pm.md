---
title: INI.pm
---

-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [SYNOPSIS](#SYNOPSIS)
-   [EXPORTED FUNCTIONS](#EXPORTED-FUNCTIONS)
    -   [groups\_file($file)](#groups_file-file-)

# NAME

Rex::Group::Lookup::INI - read hostnames and groups from a INI style file

# DESCRIPTION

With this module you can define hostgroups out of an ini style file.

# SYNOPSIS

     use Rex::Group::Lookup::INI;
     groups_file "file.ini";
     

# EXPORTED FUNCTIONS

## groups\_file($file)

With this function you can read groups from INI style files.

File example:

     [webserver]
     fe01
     fe02
     f03
        
     [backends]
     be01
     be02

It also supports hostname expressions like \[1..3\], \[1,2,3\] and \[1..5/2\].
