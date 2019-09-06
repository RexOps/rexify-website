---
title: Grouping servers
---

Rex offers you a powerfull way to group your servers. The simplest way to use groups is to just define a group name and add all your desired servers to this group.

    ```perl
    group frontends => "frontend01", "frontend02", "frontend03";
    group backends  => "backend01",  "backend02";
    ```

Rex offers also a simple notation to define server ranges, so that you don't need to type so much.

    ```perl
    group frontends => "frontend[01..03]";
    group backends  => "backend[01..02]";
    ```

This notation will just expand to frontend01, frontend02 and frontend03 for the frontends group and to backend01 and backend02 for the backends group.

Custom parameters for servers are possible with a slightly enhanced syntax since version 0.47:

    ```perl
    group frontends => "frontend01" => { user => "bob" },
      "frontend02"  => { user       => "alice" },
      "frontend03";
    ```

Because the Rexfile is a Perl script you can just use more advanced things like querying a database, ldap or your dns.

To add your groups to the tasks you have to use the group option within the task generation.

    ```perl
    task "mytask",
      group => "mygroup",
      sub {
      # do something
      };
    ```

If you need to define multiple groups for a task, you can just use an array.

    ```perl
    task "mytask",
      group => [ "mygroup", "mygroup2" ],
      sub {
      # do something
      };
    ```

## Using an INI file to define server groups

Rex offers a simple way to query ini files for group creation. To use ini files you have to use the Rex::Group::Lookup::INI module.

    ```perl
    use Rex -feature => ['1.0'];
    use Rex::Group::Lookup::INI;
    
    groups_file "/path/to/your/file.ini";
    ```

Rex expects the following format inside your INI file.

    [frontends]
    frontend01
    frontend02
    frontend03

    [backends]
    backend01
    backend02

Rex also offers a little bit advanced functions for the ini file. You can define custom parameters for each server or include groups inside groups.

    [frontends]
    frontend01
    frontend02 user=root password=f00bar auth_type=pass maintenance=1
    frontend03

    [backends]
    backend01
    backend02

    [all]
    @frontends
    @backends

These additional options (in this example maintenance can be queried with the option method from the connection object.

    ```perl
    task "prepare",
      group => "frontends",
      sub {
      if ( connection->server->option("maintenance") ) {
        say "This server is in maintenance mode, so i'm going to stop all services";
        service [ "apache2", "postfix" ] => "stop";
      }
      };
    ```

## Quering a database to define server groups

If you want to get your server groups right out of an existing database you can use DBI to connect to your database server. In this example you will learn how to connect to a MySQL database and to get the hosts out of a table.

    ```perl
    use Rex -feature => ['1.0'];
    use DBI;
    
    my $username = "dbuser";
    my $password = "dbpassword";
    my $database = "hostdb";
    my $hostname = "mysql.intern.lan";
    my $port     = 3306;
    my $dsn      = "DBI:mysql:database=$database;host=$hostname;port=$port";
    my $dbh      = DBI->connect( $username, $password );
    
    my $sth = $dbh->prepare("SELECT * FROM hostlist WHERE enabled=1");
    
    my %server_group = ();
    while ( my $row = $sth->fetchrow_hashref ) {
      my $group_name  = $row->{server_group};
      my $server_name = $row->{server_name};
      push @{ $server_group{$group_name} }, $server_name;
    }
    
    map { group $_ => @{ $server_group{$_} }; } keys %server_group;
    ```

This example expects the following column names:

-   server\_group
-   server\_name

## Creating custom groups

If there is no built-in function that fits your needs for group creation, you can do it all by yourself. Because the Rexfile is just a plain perl script and the group command is just a perl function that expects the group name as first parameter, and uses all other parameters for the servers, you can create your own function.

    ```perl
    my @list = ( "some", "list", "entries" );
    group mygroup  => grep { /list/ } @list;
    group myserver => map  { "s$_.domain.com" } qw(1 3 7);
    ```
