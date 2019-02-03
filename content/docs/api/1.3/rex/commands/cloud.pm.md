-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [SYNOPSIS](#SYNOPSIS)
-   [EXPORTED FUNCTIONS](#EXPORTED-FUNCTIONS)
    -   [cloud\_service($cloud\_service)](#cloud_service-cloud_service-)
    -   [cloud\_auth($param1, $param2, ...)](#cloud_auth-param1-param2-...-)
    -   [cloud\_region($region)](#cloud_region-region-)
    -   [cloud\_instance\_list](#cloud_instance_list)
    -   [cloud\_volume\_list](#cloud_volume_list)
    -   [cloud\_network\_list](#cloud_network_list)
    -   [cloud\_image\_list](#cloud_image_list)
    -   [cloud\_upload\_key](#cloud_upload_key)
    -   [get\_cloud\_instances\_as\_group](#get_cloud_instances_as_group)
    -   [cloud\_instance($action, $data)](#cloud_instance-action-data-)
    -   [create](#create)
    -   [start](#start)
    -   [stop](#stop)
    -   [terminate](#terminate)
    -   [get\_cloud\_regions](#get_cloud_regions)
    -   [cloud\_volume($action , $data)](#cloud_volume-action-data-)
    -   [create](#create1)
    -   [attach](#attach)
    -   [detach](#detach)
    -   [delete](#delete)
    -   [get\_cloud\_floating\_ip](#get_cloud_floating_ip)
    -   [cloud\_network](#cloud_network)
    -   [create](#create2)
    -   [delete](#delete1)
    -   [get\_cloud\_availability\_zones](#get_cloud_availability_zones)
    -   [get\_cloud\_plans](#get_cloud_plans)
    -   [get\_cloud\_operating\_systems](#get_cloud_operating_systems)
    -   [cloud\_object](#cloud_object)

# NAME

Rex::Commands::Cloud - Cloud Management Commands

# DESCRIPTION

With this Module you can manage different Cloud services. Currently it supports Amazon EC2, Jiffybox and OpenStack.

Version &lt;= 1.0: All these functions will not be reported.

# SYNOPSIS

     use Rex::Commands::Cloud;

     cloud_service "Amazon";
     cloud_auth "your-access-key", "your-private-access-key";
     cloud_region "ec2.eu-west-1.amazonaws.com";

     task "list", sub {
       print Dumper cloud_instance_list;
       print Dumper cloud_volume_list;
     };

     task "create", sub {
       my $vol_id = cloud_volume create => { size => 1, zone => "eu-west-1a", };

       cloud_instance create => {
           image_id => "ami-xxxxxxx",
           name    => "test01",
           key    => "my-key",
           volume  => $vol_id,
           zone    => "eu-west-1a",
         };
     };

     task "destroy", sub {
       cloud_volume detach => "vol-xxxxxxx";
       cloud_volume delete => "vol-xxxxxxx";

       cloud_instance terminate => "i-xxxxxxx";
     };

# EXPORTED FUNCTIONS

## cloud\_service($cloud\_service)

Define which cloud service to use.

Services  
Amazon  

Jiffybox  

OpenStack  

## cloud\_auth($param1, $param2, ...)

Set the authentication for the cloudservice.

For example for Amazon it is:

     cloud_auth($access_key, $secret_access_key);

For JiffyBox:

     cloud_auth($auth_key);

For OpenStack:

     cloud_auth(
      tenant_name => 'tenant',
      username    => 'user',
      password    => 'password',
     );

## cloud\_region($region)

Set the cloud region.

## cloud\_instance\_list

Get all instances of a cloud service.

     task "list", sub {
       for my $instance (cloud_instance_list()) {
         say "Arch  : " . $instance->{"architecture"};
         say "IP   : " . $instance->{"ip"};
         say "ID   : " . $instance->{"id"};
         say "State : " . $instance->{"state"};
       }
     };

There are some parameters for this function that can change the gathering of ip addresses for some cloud providers (like OpenStack).

     task "list", sub {
       my @instances = cloud_instance_list 
                          private_network => 'private',
                          public_network  => 'public',
                          public_ip_type  => 'floating',
                          private_ip_type => 'fixed';
     };

## cloud\_volume\_list

Get all volumes of a cloud service.

     task "list-volumes", sub {
       for my $volume (cloud_volume_list()) {
         say "ID     : " . $volume->{"id"};
         say "Zone    : " . $volume->{"zone"};
         say "State   : " . $volume->{"state"};
         say "Attached : " . $volume->{"attached_to"};
       }
     };

## cloud\_network\_list

Get all networks of a cloud service.

     task "network-list", sub {
       for my $network (cloud_network_list()) {
         say "network  : " . $network->{network};
         say "name    : " . $network->{name};
         say "id     : " . $network->{id};
       }
     };

## cloud\_image\_list

Get a list of all available cloud images.

## cloud\_upload\_key

Upload public SSH key to cloud provider

     private_key '~/.ssh/mykey
     public_key  '~/.ssh/mykey.pub';
     
     task "cloudprovider", sub {
       cloud_upload_key;

       cloud_instance create => {
         ...
       };
     };

## get\_cloud\_instances\_as\_group

Get a list of all running instances of a cloud service. This can be used for a *group* definition.

     group fe  => "fe01", "fe02", "fe03";
     group ec2 => get_cloud_instances_as_group();

## cloud\_instance($action, $data)

This function controls all aspects of a cloud instance.

## create

Create a new instance.

     cloud_instance create => {
         image_id => "ami-xxxxxx",
         key    => "ssh-key",
         name    => "fe-ec2-01",  # name is not necessary
         volume  => "vol-yyyyy",  # volume is not necessary
         zone    => "eu-west-1a",  # zone is not necessary
         floating_ip  => "89.39.38.160" # floating_ip is not necessary
       };

## start

Start an existing instance

     cloud_instance start => "instance-id";

## stop

Stop an existing instance

     cloud_instance stop => "instance-id";

## terminate

Terminate an instance. This will destroy all data and remove the instance.

     cloud_instance terminate => "i-zzzzzzz";

## get\_cloud\_regions

Returns all regions as an array.

## cloud\_volume($action , $data)

This function controlls all aspects of a cloud volume.

## create

Create a new volume. Size is in Gigabytes.

     task "create-vol", sub {
       my $vol_id = cloud_volume create => { size => 1, zone => "eu-west-1a", };
     };

## attach

Attach a volume to an instance.

     task "attach-vol", sub {
       cloud_volume attach => "vol-xxxxxx", to => "server-id";
     };

## detach

Detach a volume from an instance.

     task "detach-vol", sub {
       cloud_volume detach => "vol-xxxxxx", from => "server-id";
     };

## delete

Delete a volume. This will destroy all data.

     task "delete-vol", sub {
       cloud_volume delete => "vol-xxxxxx";
     };

## get\_cloud\_floating\_ip

Returns first available floating IP

     task "get_floating_ip", sub {

       my $ip = get_cloud_floating_ip;

       my $instance = cloud_instance create => {
          image_id => 'edffd57d-82bf-4ffe-b9e8-af22563741bf',
          name => 'instance1',
          plan_id => 17,
          floating_ip => $ip
        };
     };

## cloud\_network

## create

Create a new network.

     task "create-net", sub {
       my $net_id = cloud_network create => { cidr => '192.168.0.0/24', name => "mynetwork", };
     };

## delete

Delete a network.

     task "delete-net", sub {
       cloud_network delete => '18a4ccf8-f14a-a10d-1af4-4ac7fee08a81';
     };

## get\_cloud\_availability\_zones

Returns all availability zones of a cloud services. If available.

     task "get-zones", sub {
       print Dumper get_cloud_availability_zones;
     };

## get\_cloud\_plans

Retrieve information of the available cloud plans. If supported.

## get\_cloud\_operating\_systems

Retrieve information of the available cloud plans. If supported.

## cloud\_object

Returns the cloud object itself.
