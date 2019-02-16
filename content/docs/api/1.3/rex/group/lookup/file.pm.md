---
title: File.pm
---

-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [SYNOPSIS](#SYNOPSIS)
-   [EXPORTED FUNCTIONS](#EXPORTED-FUNCTIONS)
    -   [lookup\_file($file)](#lookup_file-file-)

# NAME

Rex::Group::Lookup::File - read hostnames from a file.

# DESCRIPTION

With this module you can define hostgroups out of a file.

# SYNOPSIS

     use Rex::Group::Lookup::File;
     group "webserver" => lookup_file("./hosts.lst");
     

# EXPORTED FUNCTIONS

## lookup\_file($file)

With this function you can read hostnames from a file. Every hostname in one line.

     group "webserver"  => lookup_file("./webserver.lst");
     group "mailserver" => lookup_file("./mailserver.lst");
