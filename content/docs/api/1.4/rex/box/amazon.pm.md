-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [EXAMPLES](#EXAMPLES)
-   [METHODS](#METHODS)
    -   [new(name =&gt; $vmname)](#new-name-vmname-)
    -   [ami($ami\_id)](#ami-ami_id-)
    -   [type($type)](#type-type-)
    -   [security\_group($sec\_group)](#security_group-sec_group-)
    -   [forward\_port(%option)](#forward_port-option-)
    -   [share\_folder(%option)](#share_folder-option-)
    -   [info](#info)

# NAME

Rex::Box::Amazon - Rex/Boxes Amazon Module

# DESCRIPTION

This is a Rex/Boxes module to use Amazon EC2.

# EXAMPLES

To use this module inside your Rexfile you can use the following commands.

     use Rex::Commands::Box;
     set box => "Amazon", {
       access_key => "your-access-key",
       private_access_key => "your-private-access-key",
       region => "ec2.eu-west-1.amazonaws.com",
       zone => "eu-west-1a",
       authkey => "default",
     };
      
     task "prepare_box", sub {
       box {
         my ($box) = @_;
           
         $box->name("mybox");
         $box->ami("ami-c1aaabb5");
         $box->type("m1.large"); 
            
         $box->security_group("default");
            
         $box->auth(
           user => "root",
           password => "box",
         );
            
         $box->setup("setup_task");
       };
     };

If you want to use a YAML file you can use the following template.

     type: Amazon
     amazon:
       access_key: your-access-key
       private_access_key: your-private-access-key
       region: ec2.eu-west-1.amazonaws.com
       zone: eu-west-1a
       auth_key: default
     vms:
       vmone:
         ami: ami-c1aaabb5
         type: m1.large
         security_group: default
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

     my $box = Rex::Box::VBox->new(name => "vmname");

## ami($ami\_id)

Set the AMI ID for the box.

## type($type)

Set the type of the Instance. For example "m1.large".

## security\_group($sec\_group)

Set the Amazon security group for this Instance.

## forward\_port(%option)

Not available for Amazon Boxes.

## share\_folder(%option)

Not available for Amazon Boxes.

## info

Returns a hashRef of vm information.
