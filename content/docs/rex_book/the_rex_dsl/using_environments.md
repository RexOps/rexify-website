With environments it is easy to group your servers depending on the maturity of your configuration or your code.

You can create environments for dev, staging and production machines. There is no limit for environments, so you can create as much as you need.

The classic way is to have 3 environments. The development environment for integration tests, mostly with fewest machines. The staging environment, mostly with the same resource layers as production. And the production environment.

<img src="../../media/book/book_env.png" width="619" height="464" />

Creating Environments
---------------------

Creating environments is as easy as creating groups. To create environments you can use the environment function. Inside an environment you can place everything that is specific for this environment (like authentication, server groups, tasks, ...).

    # Rexfile
    use Rex -feature => ['1.0'];

    environment test => sub {
      user "root";
      password "b0x";

      group frontend   => "fe01.test";
      group middleware => "mw01.test";
      group dbwrite    => "dbm01.test";
    };

    environment stage => sub {
      user "root";
      password "b0xst4g3";

      group loadbalancer => "lb01.stage";
      group frontend     => "fe01.stage";
      group middleware   => "mw01.stage";
      group dbread       => "dbs01.stage";
      group dbwrite      => "dbm01.stage";
    };

    environment live => sub {
      user "admin";
      password "b0xl1v3";
      sudo_password "b0xl1v3";
      sudo TRUE;

      group loadbalancer => "lb[01..02].live";
      group frontend     => "fe[01..03].live";
      group middleware   => "mw[01..02].live";
      group dbread       => "dbs[01..02].live";
      group dbwrite      => "dbm01.live";
    };

Running tasks
-------------

To run the task inside a special environment you have to use the cli option -E

    $ rex -E stage $task

If you need to configure systems depending on the environment you can get the current environment inside a task with the environment function.

    # Rexfile
    task "prepare", group => "frontend", make {
      # configure ntp.conf depending on the environment
      my $ntp_server = case environment, {
                         test    => ["ntp01.test"],
                         stage   => ["ntp01.stage"],
                         live    => ["ntp01.live", "ntp02.live"],
                         default => ["ntp01.test"],
                       };

      file "/etc/ntp.conf",
        content   => template("templates/etc/ntp.conf", ntp_server => $ntp_server),
        owner     => "root",
        group     => "root",
        mode      => 644,
        on_change => make { service ntpd => "restart"; };
    };

Environments and the CMDB
-------------------------

If you're using a CMDB to separate data from code you can also create YAML files for the different environments.

The lookup path for the default YAML CMDB is as follow:

-   $server.yml
-   $environment/$server.yml
-   $environment/default.yml
-   default.yml

### The YAML files

    # File: cmdb/default.yml
    ntp_server:
      - ntp01.test

    # File: cmdb/test/default.yml
    ntp_server:
      - ntp01.test

    # File: cmdb/stage/default.yml
    ntp_server:
      - ntp01.stage

    # File: cmdb/live/default.yml
    ntp_server:
      - ntp01.live
      - ntp02.live

### The Rexfile

To use the CMDB you have to require and configure the Rex::CMDB module first.

    # Rexfile
    use Rex -feature => ['1.0'];
    use Rex::CMDB;

    set cmdb => {
      type => "YAML",
      path => "./cmdb",
    };

    task "prepare", group => "frontend", make {
      # configure ntp.conf depending on the environment
      my $ntp_server = get cmdb "ntp_server";

      file "/etc/ntp.conf",
        content   => template("templates/etc/ntp.conf", ntp_server => $ntp_server),
        owner     => "root",
        group     => "root",
        mode      => 644,
        on_change => make { service ntpd => "restart"; };
    };

Now you can run the task with `rex -E test prepare`.
