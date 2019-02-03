-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [SYNOPSIS](#SYNOPSIS)
-   [EXPORTED FUNCTIONS](#EXPORTED-FUNCTIONS)
    -   [is\_port\_open($ip, $port)](#is_port_open-ip-port-)

# NAME

Rex::Commands::SimpleCheck - Simple tcp/alive checks

# DESCRIPTION

With this module you can do simple tcp/alive checks.

Version &lt;= 1.0: All these functions will not be reported.

All these functions are not idempotent.

# SYNOPSIS

     if(is_port_open($remote_host, $port)) {
       print "Port $port is open\n";
     }

# EXPORTED FUNCTIONS

## is\_port\_open($ip, $port)

Check if something is listening on port $port of $ip.
