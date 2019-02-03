-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [SYNOPSIS](#SYNOPSIS)
-   [EXPORTED FUNCTIONS](#EXPORTED-FUNCTIONS)
    -   [tail($file)](#tail-file-)

# NAME

Rex::Commands::Tail - Tail a file

Version &lt;= 1.0: All these functions will not be reported.

All these functions are not idempotent.

# DESCRIPTION

With this module you can tail a file.

# SYNOPSIS

     tail "/var/log/syslog";

# EXPORTED FUNCTIONS

## tail($file)

This function will tail the given file.

     task "syslog", "server01", sub {
       tail "/var/log/syslog";
     };

If you want to control the output format, you can define a callback function:

     task "syslog", "server01", sub {
       tail "/var/log/syslog", sub {
        my ($data) = @_;
     
        my $server = Rex->get_current_connection()->{'server'};
     
        print "$server>> $data\n";
       };
     };
