-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [SYNOPSIS](#SYNOPSIS)
-   [EXPORTED FUNCTIONS](#EXPORTED-FUNCTIONS)
    -   [route](#route)
    -   [default\_gateway(\[$default\_gw\])](#default_gateway-default_gw-)
    -   [netstat](#netstat)

# NAME

Rex::Commands::Network - Network Module

# DESCRIPTION

With this module you can get information of the routing table, current network connections, open ports, ...

# SYNOPSIS

     use Rex::Commands::Network;
     
     my @routes = route;
     print Dumper(\@routes);
     
     my $default_gw = default_gateway;
     default_gateway "192.168.2.1";
     
     my @netstat = netstat;
     my @tcp_connections = grep { $_->{"proto"} eq "tcp" } netstat;

# EXPORTED FUNCTIONS

## route

Get routing information

## default\_gateway(\[$default\_gw\])

Get or set the default gateway.

## netstat

Get network connection information
