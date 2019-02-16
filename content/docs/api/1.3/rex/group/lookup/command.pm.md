---
title: Command.pm
---

-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [SYNOPSIS](#SYNOPSIS)
-   [EXPORTED FUNCTIONS](#EXPORTED-FUNCTIONS)

# NAME

Rex::Group::Lookup::Command - read hostnames from a command.

# DESCRIPTION

With this module you can define hostgroups out of a command.

# SYNOPSIS

     use Rex::Group::Lookup::Command;
     
     group "dbserver"  => lookup_command("cat ip.list | grep -v -E '^#'");
     
     rex xxxx                            # dbserver

# EXPORTED FUNCTIONS
