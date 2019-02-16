---
title: Host.pm
---

-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [SYNOPSIS](#SYNOPSIS)
-   [EXPORTED FUNCTIONS](#EXPORTED-FUNCTIONS)
    -   [host\_entry($name, %option)](#host_entry-name-option-)
    -   [create\_host($)](#create_host-)
    -   [delete\_host($host)](#delete_host-host-)
    -   [get\_host($host)](#get_host-host-)

# NAME

Rex::Commands::Host - Edit /etc/hosts

# DESCRIPTION

With this module you can manage the host entries in /etc/hosts.

# SYNOPSIS

     task "create-host", "remoteserver", sub {
       create_host "rexify.org" => {
        ip    => "88.198.93.110",
        aliases => ["www.rexify.org"],
       };
     };

# EXPORTED FUNCTIONS

## host\_entry($name, %option)

Manages the entries in /etc/hosts.

     host_entry "rexify.org",
       ensure    => "present",
       ip        => "88.198.93.110",
       aliases   => ["www.rexify.org"],
       on_change => sub { say "added host entry"; };
     
      host_entry "rexify.org",
        ensure    => "absent",
        on_change => sub { say "removed host entry"; };

## create\_host($)

Update or create a /etc/hosts entry.

     create_host "rexify.org", {
       ip    => "88.198.93.110",
       aliases => ["www.rexify.org", ...]
     };

## delete\_host($host)

Delete a host from /etc/hosts.

     delete_host "www.rexify.org";

## get\_host($host)

Returns the information of $host in /etc/hosts.

     my @host_info = get_host "localhost";
     say "Host-IP: " . $host_info[0]->{"ip"};
