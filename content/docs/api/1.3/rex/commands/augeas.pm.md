-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [SYNOPSIS](#SYNOPSIS)
-   [EXPORTED FUNCTIONS](#EXPORTED-FUNCTIONS)
    -   [augeas($action, @options)](#augeas-action-options-)

# NAME

Rex::Commands::Augeas - An augeas module for (R)?ex

# DESCRIPTION

This is a simple module to manipulate configuration files with the help of augeas.

# SYNOPSIS

     my $k = augeas exists => "/files/etc/hosts/*/ipaddr", "127.0.0.1";
        
     augeas insert => "/files/etc/hosts",
               label => "01",
               after => "/7",
               ipaddr => "192.168.2.23",
               canonical => "test";
       
     augeas dump => "/files/etc/hosts";

     augeas modify =>
        "/files/etc/ssh/sshd_config/PermitRootLogin" => "without-password",
        on_change => sub {
           service ssh => "restart";
        };

# EXPORTED FUNCTIONS

## augeas($action, @options)

It returns 1 on success and 0 on failure.

Actions:

modify  
This modifies the keys given in @options in $file.

     augeas modify =>
               "/files/etc/hosts/7/ipaddr"    => "127.0.0.2",
               "/files/etc/hosts/7/canonical" => "test01",
               on_change                      => sub { say "I changed!" };

remove  
Remove an entry.

     augeas remove    => "/files/etc/hosts/2",
            on_change => sub { say "I changed!" };

insert  
Insert an item into the file. Here, the order of the options is important. If the order is wrong it won't save your changes.

     augeas insert => "/files/etc/hosts",
               label     => "01",
               after     => "/7",
               ipaddr    => "192.168.2.23",
               alias     => "test02",
               on_change => sub { say "I changed!" };

dump  
Dump the contents of a file to STDOUT.

     augeas dump => "/files/etc/hosts";

exists  
Check if an item exists.

     my $exists = augeas exists => "/files/etc/hosts/*/ipaddr" => "127.0.0.1";
     if($exists) {
         say "127.0.0.1 exists!";
     }

get  
Returns the value of the given item.

     my $val = augeas get => "/files/etc/hosts/1/ipaddr";
