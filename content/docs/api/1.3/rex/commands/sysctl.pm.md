---
title: Sysctl.pm
---

-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [SYNOPSIS](#SYNOPSIS)
-   [EXPORTED FUNCTIONS](#EXPORTED-FUNCTIONS)
    -   [sysctl($key \[, $val\])](#sysctl-key-val-)

# NAME

Rex::Commands::Sysctl - Manipulate sysctl

# DESCRIPTION

With this module you can set and get sysctl parameters.

Version &lt;= 1.0: All these functions will not be reported.

All these functions are not idempotent.

This function doesn't persist the entries in /etc/sysctl.conf.

# SYNOPSIS

     use Rex::Commands::Sysctl;
     
     my $data = sysctl "net.ipv4.tcp_keepalive_time";
     sysctl "net.ipv4.tcp_keepalive_time" => 1800;

# EXPORTED FUNCTIONS

## sysctl($key \[, $val\])

This function will read the sysctl key $key.

If $val is given, then this function will set the sysctl key $key.

     task "tune", "server01", sub {
       if( sysctl("net.ipv4.ip_forward") == 0 ) {
         sysctl "net.ipv4.ip_forward" => 1;
       }
     };
