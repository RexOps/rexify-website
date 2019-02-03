-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [SYNOPSIS](#SYNOPSIS)
-   [EXPORTED FUNCTIONS](#EXPORTED-FUNCTIONS)
    -   [db](#db)

# NAME

Rex::Commands::DB - Simple Database Access

# DESCRIPTION

This module gives you simple access to a database. Currently *select*, *delete*, *insert* and *update* is supported.

Version &lt;= 1.0: All these functions will not be reported.

# SYNOPSIS

     use Rex::Commands::DB {
                      dsn    => "DBI:mysql:database=test;host=dbhost",
                      user    => "username",
                      password => "password",
                    };
     
     task "list", sub {
       my @data = db select => {
                fields => "*",
                from  => "table",
                where  => "enabled=1",
              };
     
      db insert => "table", {
               field1 => "value1",
                field2 => "value2",
                field3 => 5,
              };
     
      db update => "table", {
                  set => {
                    field1 => "newvalue",
                    field2 => "newvalue2",
                  },
                  where => "id=5",
               };
     
      db delete => "table", {
                where => "id < 5",
              };
     
     };

# EXPORTED FUNCTIONS

## db

Do a database action.

     my @data = db select => {
              fields => "*",
              from  => "table",
              where  => "host='myhost'",
            };
     
     db insert => "table", {
              field1 => "value1",
              field2 => "value2",
              field3 => 5,
            };
     
     db update => "table", {
                set => {
                  field1 => "newvalue",
                  field2 => "newvalue2",
                },
                where => "id=5",
             };
     
     db delete => "table", {
              where => "id < 5",
            };
