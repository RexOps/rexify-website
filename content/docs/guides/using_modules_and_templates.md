---
title: Using Modules and Templates
---

Uploading hardcoded configuration files to your servers often isn't enough. Sometimes you must add values dynamically inside a file. For example if you want to bind a service to a special network interface or to configure different database servers for your application for your different environments. This can be easily achieved with templates.

In this example you will learn how to build a ntp module that uploads custom ntp.conf files for your test-, pre-prod-, and production environment.

First, we create a new module. For this guide you need at least Rex 0.41 (because of the --create-module command and the case keyword.) Execute the following command in the same directory where your Rexfile lives.

    rexify Service::NTP --create-module

This will create some new directories and files in your lib directory.

    .
    ├── Rexfile
    └── lib
        └── Service
            └── NTP
                ├── __module__.pm
                └── meta.yml

The meta.yml file can be ignored. This file is only important if you want to share your module on the Rex modules directory.

The important file is \_\_module\_\_.pm. Open this file in an editor.
This file is a normal Perl module. The only special thing is the filename, but don't think too much for it at first.

    ```perl
    package Service::NTP;
    use Rex -feature => ['1.3'];

    task prepare => sub {
       my $service_name = case operating_system, {
                             Debian  => "ntp",
                             default => "ntpd",
                          };
       pkg "ntp",
         ensure => "present";

       file "/etc/ntp.conf",
          source    => "files/etc/ntp.conf",
          on_change => sub {
             service $service_name => "restart";
          };

       service $service_name,
         ensure => "started";
    };

    1;
    ```

First the module checks if the OS is a debian (or ubuntu) and set the service name to "ntp" otherwise to "ntpd". After that it installs the "ntp" package and uploads the configuration file. Notice the on\_change hook here. This will restart the ntp service if the file changes. At last Rex verifies that the service will start on system boot.
Now it is time to create a basic ntp.conf file. Create the directory lib/Service/NTP/files/etc and place the ntp.conf file in there.

    ```
    # /etc/ntp.conf, managed by Rex

    driftfile /var/run/ntp.drift

    statistics loopstats peerstats clockstats
    filegen loopstats file loopstats type day enable
    filegen peerstats file peerstats type day enable
    filegen clockstats file clockstats type day enable

    server ntp01.company.tld
    server ntp02.company.tld
    ```

If you now want to distribute different ntp.conf files per environment you can add multiple ntp.conf files to that directory. Rex will than decide with the help of the -E $env cli parameter which file to use. Rex first try to find a file named ntp.conf.$environment and if that file does not exist it fallback to ntp.conf.

    ```
    .
    ├── Rexfile
    └── lib
        └── Service
            └── NTP
                ├── __module__.pm
                ├── files
                │   └── etc
                │       ├── ntp.conf
                │       ├── ntp.conf.preprod
                │       ├── ntp.conf.prod
                │       └── ntp.conf.test
                └── meta.yml
    ```

But if you want to change a parameter in your ntp.conf file you have to edit 4 files. This is not realy cool. To prevent that you can use templates.

    ```perl
    package Service::NTP;
    use Rex -feature => ['1.0'];

    task prepare => sub {
       my $service_name = case operating_system, {
                             Debian  => "ntp",
                             default => "ntpd",
                          };

       my $ntp_server   = case environment, {
                             prod    => ["ntp01.company.tld", "ntp02.company.tld"],
                             preprod => ["ntp01.preprod.company.tld"],
                             test    => ["ntp01.test.company.tld"],
                             default => ["ntp01.company.tld"],
                          };

       pkg "ntp",
         ensure => "present";

       file "/etc/ntp.conf",
          content   => template("files/etc/ntp.conf", ntp_servers => $ntp_server),
          on_change => sub {
             service $service_name => "restart";
          };

       service $service_name,
         ensure => "started";
    };

    1;
    ```

Now we can create our template. The default template of Rex looks similar to other templating engines. But you can also use other template engines like Template::Toolkit.

    # /etc/ntp.conf, managed by Rex

    driftfile /var/run/ntp.drift

    statistics loopstats peerstats clockstats
    filegen loopstats file loopstats type day enable
    filegen peerstats file peerstats type day enable
    filegen clockstats file clockstats type day enable

    <% for my $server (@{ $ntp_servers }) { %>
    server <%= $server %>
    <% } %>

## Predefined Variables

There are also some predefined variables you can use in your templates. For example the ip address of a network device if you want to bind a service on a specific ip. You can dump all predefined variable of a system with the following code.

    ```perl
    task "get_infos", "server01", sub {
       dump_system_information;
    };
    ```

For example this is the output of a CentOS VM

    $kernelversion = '#1 SMP Tue May 15 22:09:39 BST 2012'
    $memory_cached = '357'
    $memory_total = '498'
    $kernelrelease = '2.6.32-220.17.1.el6.i686'
    $Kernel = {
          kernelversion => '#1 SMP Tue May 15 22:09:39 BST 2012'
          architecture => 'i686'
          kernel => 'Linux'
          kernelrelease => '2.6.32-220.17.1.el6.i686'
       }
    $hostname = 'c6test0232'
    $operatingsystem = 'CentOS'
    $operatingsystemrelease = '6.2'
    $architecture = 'i686'
    $domain = 'test.rexify.org'
    $eth0_mac = '00:1C:42:9E:0E:28'
    $kernel = 'Linux'
    $swap_free = '2005'
    $VirtInfo = {
          virtualization_role => 'guest'
          virtualization_type => 'parallels'
       }
    $memory_shared = '0'
    $Network = {
          networkdevices => [
             'eth0'
          ]
          networkconfiguration => {
             eth0 => {
                broadcast => '10.211.55.255'
                ip => '10.211.55.60'
                netmask => '255.255.255.0'
                mac => '00:1C:42:9E:0E:28'
             }
          }
       }
    $memory_used = '440'
    $kernelname = 'Linux'
    $Swap = {
          free => '2005'
          used => '10'
          total => '2015'
       }
    $swap_total = '2015'
    $memory_buffers = '47'
    $eth0_ip = '10.211.55.60'
    $swap_used = '10'
    $memory_free = '57'
    $manufacturer = 'Parallels Software International Inc.'
    $Memory = {
          shared => '0'
          buffers => '47'
          free => '57'
          used => '440'
          total => '498'
          cached => '357'
       }
    $eth0_broadcast = '10.211.55.255'
    $eth0_netmask = '255.255.255.0'
    $Host = {
          domain => 'test.rexify.org'
          manufacturer => 'Parallels Software International Inc.'
          kernelname => 'Linux'
          hostname => 'c6test0232'
          operatingsystemrelease => '6.2'
          operatingsystem => 'CentOS'
       }

You can use such predefined variable right in your template. Lets assume you want to bind apache only on your eth1 ip.

    Listen <%= $eth1_ip %>:80

## Using the Module

To use your module you have to add it to your Rexfile. This can be simply achieved with one line.

    ```perl
    use Rex -feature => ['1.3'];
    user "root";
    password "foo";

    require Service::NTP;

    1;
    ```

Than you can list your Tasks and execute them.

    $ rex -T
    [2013-03-30 02:35:32] INFO - eval your Rexfile.
    Tasks
      Service:NTP:prepare

    $ rex -H yourserver01 Service:NTP:prepare
