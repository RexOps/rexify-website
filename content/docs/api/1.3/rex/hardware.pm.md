---
title: Hardware.pm
---

-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [SYNOPSIS](#SYNOPSIS)
-   [CLASS METHODS](#CLASS-METHODS)
    -   [get(@modules)](#get-modules-)

# NAME

Rex::Hardware - Base Class for hardware / information gathering

# DESCRIPTION

This module is the base class for hardware/information gathering.

# SYNOPSIS

     use Rex::Hardware;
     
     my %host_info = Rex::Hardware->get(qw/ Host /);
     my %all_info  = Rex::Hardware->get(qw/ All /);

# CLASS METHODS

## get(@modules)

Returns a hash with the wanted information.

     task "get-info", "server1", sub {
       %hw_info = Rex::Hardware->get(qw/ Host Network /);
     };

Or if you want to get all information

     task "get-all-info", "server1", sub {
       %hw_info = Rex::Hardware->get(qw/ All /);
     };

Available modules:

Host  

Kernel  

Memory  

Network  

Swap  

VirtInfo  
