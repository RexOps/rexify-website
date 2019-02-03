-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [SYNOPSIS](#SYNOPSIS)
-   [EXPORTED FUNCTIONS](#EXPORTED-FUNCTIONS)
    -   [open\_port($port, $option)](#open_port-port-option-)
    -   [close\_port($port, $option)](#close_port-port-option-)
    -   [redirect\_port($in\_port, $option)](#redirect_port-in_port-option-)
    -   [iptables(@params)](#iptables-params-)
    -   [is\_nat\_gateway](#is_nat_gateway)
    -   [default\_state\_rule(%option)](#default_state_rule-option-)
    -   [iptables\_list](#iptables_list)
    -   [iptables\_clear](#iptables_clear)

# NAME

Rex::Commands::Iptables - Iptable Management Commands

# DESCRIPTION

With this Module you can manage basic Iptables rules.

Version &lt;= 1.0: All these functions will not be reported.

Only *open\_port* and *close\_port* are idempotent.

# SYNOPSIS

     use Rex::Commands::Iptables;
     
     task "firewall", sub {
       iptables_clear;
     
       open_port 22;
       open_port [22, 80] => {
         dev => "eth0",
       };
     
       close_port 22 => {
         dev => "eth0",
       };
       close_port "all";
     
       redirect_port 80 => 10080;
       redirect_port 80 => {
         dev => "eth0",
         to  => 10080,
       };
     
       default_state_rule;
       default_state_rule dev => "eth0";
     
       is_nat_gateway;
     
       iptables t => "nat",
             A => "POSTROUTING",
             o => "eth0",
             j => "MASQUERADE";

       # The 'iptables' function also accepts long options,
       # however, options with dashes need to be quoted
       iptables table => "nat",
             accept          => "POSTROUTING",
             "out-interface" => "eth0",
             jump            => "MASQUERADE";

       # Version of IP can be specified in the first argument
       # of any function: -4 or -6 (defaults to -4)
       iptables_clear -6;

       open_port -6, [22, 80];
       close_port -6, "all";
       redirect_port -6, 80 => 10080;
       default_state_rule -6;

       iptables -6, "flush";
       iptables -6,
             t     => "filter",
             A     => "INPUT",
             i     => "eth0",
             m     => "state",
             state => "RELATED,ESTABLISHED",
             j     => "ACCEPT";
     };

# EXPORTED FUNCTIONS

## open\_port($port, $option)

Open a port for inbound connections.

     task "firewall", sub {
       open_port 22;
       open_port [22, 80];
       open_port [22, 80],
         dev => "eth1";
     };
     
     task "firewall", sub {
      open_port 22,
        dev    => "eth1",
        only_if => "test -f /etc/firewall.managed";
    } ;

## close\_port($port, $option)

Close a port for inbound connections.

     task "firewall", sub {
       close_port 22;
       close_port [22, 80];
       close_port [22, 80],
         dev    => "eth0",
         only_if => "test -f /etc/firewall.managed";
     };

## redirect\_port($in\_port, $option)

Redirect $in\_port to another local port.

     task "redirects", sub {
       redirect_port 80 => 10080;
       redirect_port 80 => {
         to  => 10080,
         dev => "eth0",
       };
     };

## iptables(@params)

Write standard iptable comands.

Note that there is a short form for the iptables `--flush` option; when you pass the option of `-F|"flush"` as the only argument, the command `iptables -F` is run on the connected host. With the two argument form of `flush` shown in the examples below, the second argument is table you want to flush.

     task "firewall", sub {
       iptables t => "nat", A => "POSTROUTING", o => "eth0", j => "MASQUERADE";
       iptables t => "filter", i => "eth0", m => "state", state => "RELATED,ESTABLISHED", j => "ACCEPT";
     
       # automatically flushes all tables; equivalent to 'iptables -F'
       iptables "flush";
       iptables -F;

       # flush only the "filter" table
       iptables flush => "filter";
       iptables -F => "filter";
     };

     # Note: options with dashes "-" need to be quoted to escape them from Perl
     task "long_form_firewall", sub {
       iptables table => "nat",
            append          => "POSTROUTING",
            "out-interface" => "eth0",
            jump            => "MASQUERADE";
       iptables table => "filter",
            "in-interface" => "eth0",
            match          => "state",
            state          => "RELATED,ESTABLISHED",
            jump           => "ACCEPT";
     };

## is\_nat\_gateway

This function creates a NAT gateway for the device the default route points to.

     task "make-gateway", sub {
       is_nat_gateway;
       is_nat_gateway -6;
     };

## default\_state\_rule(%option)

Set the default state rules for the given device.

     task "firewall", sub {
       default_state_rule(dev => "eth0");
     };

## iptables\_list

List all iptables rules.

     task "list-iptables", sub {
       print Dumper iptables_list;
       print Dumper iptables_list -6;
     };

## iptables\_clear

Remove all iptables rules.

     task "no-firewall", sub {
       iptables_clear;
     };
