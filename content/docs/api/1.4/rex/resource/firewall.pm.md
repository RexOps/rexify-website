---
title: firewall.pm
---

-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [SYNOPSIS](#SYNOPSIS)
-   [EXPORTED RESOURCES](#EXPORTED-RESOURCES)

# NAME

Rex::Resource::firewall - Firewall functions

# DESCRIPTION

With this module it is easy to manage different firewall systems.

# SYNOPSIS

     # Configure a particular rule
     task "configure_firewall", "server01", sub {
       firewall "some-name",
         ensure      => "present",
         proto       => "tcp",
         action      => "accept",
         source      => "192.168.178.0/24",
         destination => "192.168.1.0/24",
         sport       => 80,
         sapp        => 'www',    # source application, if provider supports it
         port        => 80,       # same as dport
         dport       => 80,
         app         => 'www',    # same as dapp, destination application, if provider supports it
         dapp        => 'www',    # destination application, if provider supports it
         tcp_flags   => ["FIN", "SYN", "RST"],
         chain       => "INPUT",
         table       => "nat",
         jump        => "LOG",
         iniface     => "eth0",
         outiface    => "eth1",
         reject_with => "icmp-host-prohibited",
         log         => "new|all",  # if provider supports it
         log_level   => "",         # if provider supports it
         log_prefix  => "FW:",      # if provider supports it
         state       => "NEW",
         ip_version  => -4;         # for iptables provider. valid options -4 and -6
     };

     # Add overall logging (if provider supports)
     firewall "some-name",
       provider => 'ufw',
       logging  => "medium";

# EXPORTED RESOURCES

firewall($name, %params)  
