---
title: Logger.pm
---

-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [SYNOPSIS](#SYNOPSIS)
-   [VARIABLES](#VARIABLES)

# NAME

Rex::Logger - Logging Module

# DESCRIPTION

This module is the logging module. You can define custom logformats.

# SYNOPSIS

     $Rex::Logger::format = '[%D] %s';
     # will output something like
     # [2012-04-12 18:35:12] Installing package vim
       
     $Rex::Logger::format = '%h - %D - %s';
     # will output something like
     # srv001 - 2012-04-12 18:35:12 - Installing package vim

# VARIABLES

$debug  
Setting this variable to 1 will enable debug logging.

     $Rex::Logger::debug = 1;

$silent  
If you set this variable to 1 nothing will be logged.

     $Rex::Logger::silent = 1;

$format  
You can define the logging format with the following parameters.

%D - Appends the current date yyyy-mm-dd HH:mm:ss

%h - The target host

%p - The pid of the running process

%l - Loglevel (INFO or DEBUG)

%s - The Logstring

Default is: \[%D\] %l - %s
