-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [EXAMPLES](#EXAMPLES)
-   [METHODS](#METHODS)
    -   [new(name =&gt; $vmname)](#new-name-vmname-)
    -   [memory($memory\_size)](#memory-memory_size-)
    -   [info](#info)
    -   [ip](#ip)

# NAME

Rex::Box::KVM - Rex/Boxes KVM Module

# DESCRIPTION

This is a Rex/Boxes module to use KVM VMs. You need to have libvirt installed.

# EXAMPLES

To use this module inside your Rexfile you can use the following commands.

     use Rex::Commands::Box;
     set box => "KVM";
     
     task "prepare_box", sub {
        box {
           my ($box) = @_;
     
           $box->name("mybox");
           $box->url("http://box.rexify.org/box/ubuntu-server-12.10-amd64.kvm.qcow2");
     
           $box->network(1 => {
              name => "default",
           });
     
           $box->auth(
              user => "root",
              password => "box",
           );
     
           $box->setup("setup_task");
        };
     };

If you want to use a YAML file you can use the following template.

     type: KVM
     vms:
        vmone:
           url: http://box.rexify.org/box/ubuntu-server-12.10-amd64.kvm.qcow2
           setup: setup_task

And then you can use it the following way in your Rexfile.

     use Rex::Commands::Box init_file => "file.yml";
     
     task "prepare_vms", sub {
        boxes "init";
     };

# METHODS

See also the Methods of Rex::Box::Base. This module inherits all methods of it.

## new(name =&gt; $vmname)

Constructor if used in OO mode.

     my $box = Rex::Box::KVM->new(name => "vmname");

## memory($memory\_size)

Sets the memory of a VM in megabyte.

## info

Returns a hashRef of vm information.

## ip

This method return the ip of a vm on which the ssh daemon is listening.
