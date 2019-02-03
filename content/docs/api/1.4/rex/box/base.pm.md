-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [METHODS](#METHODS)
    -   [info](#info)
    -   [name($vmname)](#name-vmname-)
    -   [setup(@tasks)](#setup-tasks-)
    -   [storage('path/to/vm/disk')](#storage-path-to-vm-disk-)
    -   [import\_vm()](#import_vm-)
    -   [stop()](#stop-)
    -   [start()](#start-)
    -   [ip()](#ip-)
    -   [status()](#status-)
    -   [provision\_vm(\[@tasks\])](#provision_vm-tasks-)
    -   [cpus($count)](#cpus-count-)
    -   [memory($memory\_size)](#memory-memory_size-)
    -   [network(%option)](#network-option-)
    -   [forward\_port(%option)](#forward_port-option-)
    -   [list\_boxes](#list_boxes)
    -   [url($url)](#url-url-)
    -   [auth(%option)](#auth-option-)

# NAME

Rex::Box::Base - Rex/Boxes Base Module

# DESCRIPTION

This is a Rex/Boxes base module.

# METHODS

These methods are shared across all other Rex::Box modules.

## info

Returns a hashRef of vm information.

## name($vmname)

Sets the name of the virtual machine.

## setup(@tasks)

Sets the tasks that should be executed as soon as the VM is available through SSH.

## storage('path/to/vm/disk')

Sets the disk path of the virtual machine. Works only on KVM

## import\_vm()

This method must be overwritten by the implementing class.

## stop()

Stops the VM.

## start()

Starts the VM.

## ip()

Return the ip:port to which rex will connect to.

## status()

Returns the status of a VM.

Valid return values are "running" and "stopped".

## provision\_vm(\[@tasks\])

Executes the given tasks on the VM.

## cpus($count)

Set the amount of CPUs for the VM.

## memory($memory\_size)

Sets the memory of a VM in megabyte.

## network(%option)

Configure the network for a VM.

Currently it supports 2 modes: *nat* and *bridged*. Currently it supports only one network card.

     $box->network(
       1 => {
         type => "nat",
       },
     }
     
     $box->network(
       1 => {
         type => "bridged",
         bridge => "eth0",
       },
     );

## forward\_port(%option)

Set ports to be forwarded to the VM. This is not supported by all Box providers.

     $box->forward_port(
       name => [$from_host_port, $to_vm_port],
       name2 => [$from_host_port_2, $to_vm_port_2],
       ...
     );

## list\_boxes

List all available boxes.

## url($url)

The URL where to download the Base VM Image. You can use self-made images or prebuild images from http://box.rexify.org/.

## auth(%option)

Configure the authentication to the VM.

     $box->auth(
       user => $user,
       password => $password,
       private_key => $private_key,
       public_key => $public_key,
     );
