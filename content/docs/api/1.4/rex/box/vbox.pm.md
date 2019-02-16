---
title: VBox.pm
---

-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [EXAMPLES](#EXAMPLES)
-   [HEADLESS MODE](#HEADLESS-MODE)
-   [METHODS](#METHODS)
    -   [new(name =&gt; $vmname)](#new-name-vmname-)
    -   [share\_folder(%option)](#share_folder-option-)
    -   [info](#info)
    -   [ip](#ip)

# NAME

Rex::Box::VBox - Rex/Boxes VirtualBox Module

# DESCRIPTION

This is a Rex/Boxes module to use VirtualBox VMs.

# EXAMPLES

To use this module inside your Rexfile you can use the following commands.

     use Rex::Commands::Box;
     set box => "VBox";
     
     task "prepare_box", sub {
       box {
         my ($box) = @_;
     
         $box->name("mybox");
         $box->url("http://box.rexify.org/box/ubuntu-server-12.10-amd64.ova");
     
         $box->network(1 => {
           type => "nat",
         });
     
         $box->network(1 => {
           type => "bridged",
           bridge => "eth0",
         });
     
         $box->forward_port(ssh => [2222, 22]);
     
         $box->share_folder(myhome => "/home/myuser");
     
         $box->auth(
           user => "root",
           password => "box",
         );
     
         $box->setup("setup_task");
       };
     };

If you want to use a YAML file you can use the following template.

     type: VBox
     vms:
       vmone:
         url: http://box.rexify.org/box/ubuntu-server-12.10-amd64.ova
         forward_port:
           ssh:
             - 2222
             - 22
         share_folder:
           myhome: /home/myhome
         setup: setup_task

And then you can use it the following way in your Rexfile.

     use Rex::Commands::Box init_file => "file.yml";
     
     task "prepare_vms", sub {
       boxes "init";
     };

# HEADLESS MODE

It is also possible to run VirtualBox in headless mode. This only works on Linux and MacOS. If you want to do this you can use the following option at the top of your *Rexfile*.

     set box_options => { headless => TRUE };

# METHODS

See also the Methods of Rex::Box::Base. This module inherits all methods of it.

## new(name =&gt; $vmname)

Constructor if used in OO mode.

     my $box = Rex::Box::VBox->new(name => "vmname");

## share\_folder(%option)

Creates a shared folder inside the VM with the content from a folder from the Host machine. This only works with VirtualBox.

     $box->share_folder(
       name => "/path/on/host",
       name2 => "/path_2/on/host",
     );

## info

Returns a hashRef of vm information.

## ip

This method return the ip of a vm on which the ssh daemon is listening.
