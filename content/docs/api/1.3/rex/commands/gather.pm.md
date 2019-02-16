---
title: Gather.pm
---

-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [SYNOPSIS](#SYNOPSIS)
-   [EXPORTED FUNCTIONS](#EXPORTED-FUNCTIONS)
    -   [get\_operating\_system](#get_operating_system)
    -   [operating\_system](#operating_system)
    -   [get\_system\_information](#get_system_information)
    -   [dump\_system\_information](#dump_system_information)
    -   [operating\_system\_is($string)](#operating_system_is-string-)
    -   [operating\_system\_version()](#operating_system_version-)
    -   [operating\_system\_release()](#operating_system_release-)
    -   [network\_interfaces](#network_interfaces)
    -   [memory](#memory)
    -   [is\_freebsd](#is_freebsd)
    -   [is\_redhat](#is_redhat)
    -   [is\_fedora](#is_fedora)
    -   [is\_suse](#is_suse)
    -   [is\_mageia](#is_mageia)
    -   [is\_debian](#is_debian)
    -   [is\_alt](#is_alt)
    -   [is\_netbsd](#is_netbsd)
    -   [is\_openbsd](#is_openbsd)
    -   [is\_linux](#is_linux)
    -   [is\_bsd](#is_bsd)
    -   [is\_solaris](#is_solaris)
    -   [is\_windows](#is_windows)
    -   [is\_openwrt](#is_openwrt)
    -   [is\_gentoo](#is_gentoo)

# NAME

Rex::Commands::Gather - Hardware and Information gathering

# DESCRIPTION

With this module you can gather hardware and software information.

All these functions will not be reported. These functions don't modify anything.

# SYNOPSIS

     operating_system_is("SuSE");

# EXPORTED FUNCTIONS

## get\_operating\_system

Will return the current operating system name.

     task "get-os", "server01", sub {
       say get_operating_system();
     };

Aliased by operating\_system().

## operating\_system

Alias for get\_operating\_system()

## get\_system\_information

Will return a hash of all system information. These Information will be also used by the template function.

## dump\_system\_information

This function dumps all known system information on stdout.

## operating\_system\_is($string)

Will return 1 if the operating system is $string.

     task "is_it_suse", "server01", sub {
       if( operating_system_is("SuSE") ) {
         say "This is a SuSE system.";
       }
     };

## operating\_system\_version()

Will return the os release number as an integer. For example, it will convert 5.10 to 510, 10.04 to 1004 or 6.0.3 to 603.

     task "prepare", "server01", sub {
       if( operating_system_version() >= 510 ) {
         say "OS Release is higher or equal to 510";
       }
     };

## operating\_system\_release()

Will return the os release number as is.

## network\_interfaces

Return an HashRef of all the networkinterfaces and their configuration.

     task "get_network_information", "server01", sub {
       my $net_info = network_interfaces();
     };

You can iterate over the devices as follow

     my $net_info = network_interfaces();
     for my $dev ( keys %{ $net_info } ) {
       say "$dev has the ip: " . $net_info->{$dev}->{"ip"} . " and the netmask: " . $net_info->{$dev}->{"netmask"};
     }

## memory

Return an HashRef of all memory information.

     task "get_memory_information", "server01", sub {
       my $memory = memory();

       say "Total:  " . $memory->{"total"};
       say "Free:   " . $memory->{"free"};
       say "Used:   " . $memory->{"used"};
       say "Cached:  " . $memory->{"cached"};
       say "Buffers: " . $memory->{"buffers"};
     };

## is\_freebsd

Returns true if the target system is a FreeBSD.

     task "foo", "server1", "server2", sub {
       if(is_freebsd) {
         say "This is a freebsd system...";
       }
       else {
         say "This is not a freebsd system...";
       }
     };

## is\_redhat

     task "foo", "server1", sub {
       if(is_redhat) {
         # do something on a redhat system (like RHEL, Fedora, CentOS, Scientific Linux
       }
     };

## is\_fedora

     task "foo", "server1", sub {
       if(is_fedora) {
         # do something on a fedora system
       }
     };

## is\_suse

     task "foo", "server1", sub {
       if(is_suse) {
         # do something on a suse system
       }
     };

## is\_mageia

     task "foo", "server1", sub {
       if(is_mageia) {
         # do something on a mageia system (or other Mandriva followers)
       }
     };

## is\_debian

     task "foo", "server1", sub {
       if(is_debian) {
         # do something on a debian system
       }
     };

## is\_alt

     task "foo", "server1", sub {
       if(is_alt) {
         # do something on a ALT Linux system
       }
     };

## is\_netbsd

Returns true if the target system is a NetBSD.

     task "foo", "server1", "server2", sub {
       if(is_netbsd) {
         say "This is a netbsd system...";
       }
       else {
         say "This is not a netbsd system...";
       }
     };

## is\_openbsd

Returns true if the target system is an OpenBSD.

     task "foo", "server1", "server2", sub {
       if(is_openbsd) {
         say "This is an openbsd system...";
       }
       else {
         say "This is not an openbsd system...";
       }
     };

## is\_linux

Returns true if the target system is a Linux System.

     task "prepare", "server1", "server2", sub {
       if(is_linux) {
        say "This is a linux system...";
       }
       else {
        say "This is not a linux system...";
       }
     };

## is\_bsd

Returns true if the target system is a BSD System.

     task "prepare", "server1", "server2", sub {
       if(is_bsd) {
        say "This is a BSD system...";
       }
       else {
        say "This is not a BSD system...";
       }
     };

## is\_solaris

Returns true if the target system is a Solaris System.

     task "prepare", "server1", "server2", sub {
       if(is_solaris) {
        say "This is a Solaris system...";
       }
       else {
        say "This is not a Solaris system...";
       }
     };

## is\_windows

Returns true if the target system is a Windows System.

## is\_openwrt

Returns true if the target system is an OpenWrt System.

## is\_gentoo

Returns true if the target system is a Gentoo System.
