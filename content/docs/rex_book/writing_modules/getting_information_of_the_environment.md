---
title: Getting information of the environment
---

Often you need to know some things of the environment where you are currently connected. For example if you need to install apache on Debian and CentOS you have to provide different packages names.

Rex comes with a hardware gathering module. To display all the things Rex knows about the environment your can create a test task that just dumps all the information.

    use Rex -feature => ['1.0'];

    task "dump-info", sub {
       dump_system_information;
    };

This will print out everything Rex knows about the remote system. You can use these information inside your Rexfile or a template.

A sample output (CentOS 5.9 running inside KVM)

    $kernelversion = '#1 SMP Tue May 21 15:29:55 EDT 2013'
    $memory_cached = '127'
    $memory_total = '497'
    $kernelrelease = '2.6.18-348.6.1.el5'
    $Kernel = {
          kernelversion => '#1 SMP Tue May 21 15:29:55 EDT 2013'
          architecture => 'x86_64'
          kernel => 'Linux'
          kernelrelease => '2.6.18-348.6.1.el5'
       }
    $hostname = 'centos-5-amd64.rexify.org'
    $operatingsystem = 'CentOS'
    $operatingsystemrelease = '5.9'
    $architecture = 'x86_64'
    $domain = ''
    $eth0_mac = '52:54:00:E8:69:15'
    $kernel = 'Linux'
    $swap_free = '1023'
    $VirtInfo = {
          virtualization_role => 'guest'
          virtualization_type => 'kvm'
       }
    $memory_shared = '0'
    $Network = {
          networkdevices => [
             'eth0'
          ]
          networkconfiguration => {
             eth0 => {
                broadcast => '192.168.122.255'
                ip => '192.168.122.22'
                netmask => '255.255.255.0'
                mac => '52:54:00:E8:69:15'
             }
          }
       }
    $memory_used = '218'
    $kernelname = 'Linux'
    $Swap = {
          free => '1023'
          used => '0'
          total => '1023'
       }
    $swap_total = '1023'
    $memory_buffers = '12'
    $eth0_ip = '192.168.122.22'
    $swap_used = '0'
    $memory_free = '278'
    $manufacturer = 'Bochs'
    $Memory = {
          shared => '0'
          buffers => '12'
          free => '278'
          used => '218'
          total => '497'
          cached => '127'
       }
    $eth0_broadcast = '192.168.122.255'
    $eth0_netmask = '255.255.255.0'
    $Host = {
          domain => ''
          manufacturer => 'Bochs'
          kernelname => 'Linux'
          hostname => 'centos-5-amd64.rexify.org'
          operatingsystemrelease => '5.9'
          operatingsystem => 'CentOS'
       }

To use these information inside the Rexfile you can query them with the get\_system\_information function or use the methods from the connection object

    use Rex -feature => ['1.0'];

    task "get_hostname", sub {
       my %info = get_system_information;
       say $info{hostname} . "." . $info{domain};
    };

    use Rex -feature => ['1.0'];

    task "prepare", sub {
       my $libpath = case connection->server->architecture,
                         "i386"   => "/usr/lib",
                         "x86_64" => "/usr/lib64";
    };

## Using environment information inside templates

You can also use these information inside your template. For example if you want to add the ip address of eth0 or the hostname into a file or change settings of an application based on memory size.

    Listen <%= $eth0_ip %>:80
