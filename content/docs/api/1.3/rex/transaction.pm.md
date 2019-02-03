-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [SYNOPSIS](#SYNOPSIS)
-   [EXPORTED FUNCTIONS](#EXPORTED-FUNCTIONS)
    -   [transaction($codeRef)](#transaction-codeRef-)
    -   [on\_rollback($codeRef)](#on_rollback-codeRef-)

# NAME

Rex::Transaction - Transaction support.

# DESCRIPTION

With this module you can define transactions and rollback scenarios on failure.

# SYNOPSIS

     task "do-something", "server01", sub {
       transaction {
         on_rollback {
           rmdir "/tmp/mydata";
         };
     
         mkdir "/tmp/mydata";
         upload "files/myapp.tar.gz", "/tmp/mydata";
         run "cd /tmp/mydata; tar xzf myapp.tar.gz";
         if($? != 0) { die("Error extracting myapp.tar.gz"); }
       };
     };

# EXPORTED FUNCTIONS

## transaction($codeRef)

Start a transaction for $codeRef. If $codeRef dies it will rollback the transaction.

     task "deploy", group => "frontend", sub {
        on_rollback {
          rmdir "...";
        };
        deploy "myapp.tar.gz";
     };
      
     task "restart_server", group => "frontend", sub {
        run "/etc/init.d/apache2 restart";
     };
      
     task "all", group => "frontend", sub {
        transaction {
          do_task [qw/deploy restart_server/];
        };
     };

## on\_rollback($codeRef)

This code will be executed if one step in the transaction fails.

See *transaction*.
