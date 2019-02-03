-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [SYNOPSIS](#SYNOPSIS)
-   [EXPORTED FUNCTIONS](#EXPORTED-FUNCTIONS)
    -   [new(name =&gt; $box\_name)](#new-name-box_name-)
    -   [box(sub {})](#box-sub-)
    -   [list\_boxes](#list_boxes)
    -   [get\_box($box\_name)](#get_box-box_name-)
    -   [boxes($action, @data)](#boxes-action-data-)

# NAME

Rex::Commands::Box - Functions / Class to manage Virtual Machines

# DESCRIPTION

This is a Module to manage Virtual Machines or Cloud Instances in a simple way. Currently it supports Amazon, KVM and VirtualBox.

Version &lt;= 1.0: All these functions will not be reported.

# SYNOPSIS

     use Rex::Commands::Box;
     
     set box => "VBox";
     
     group all_my_boxes => map { get_box($_->{name})->{ip} } list_boxes;
     
     task mytask => sub {
     
       box {
         my ($box) = @_;
         $box->name("boxname");
         $box->url("http://box.rexify.org/box/base-image.box");
     
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
     
         $box->setup(qw/task_to_customize_box/);
     
       };
     
     };

# EXPORTED FUNCTIONS

## new(name =&gt; $box\_name)

Constructor if used in OO mode.

     my $box = Rex::Commands::Box->new(name => "box_name");

## box(sub {})

With this function you can create a new Rex/Box. The first parameter of this function is the Box object. With this object you can define your box.

     box {
       my ($box) = @_;
       $box->name("boxname");
       $box->url("http://box.rexify.org/box/base-image.box");
     
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
     
       $box->setup(qw/task_to_customize_box/);
     };

## list\_boxes

This function returns an array of hashes containing all information that can be gathered from the hypervisor about the Rex/Box. This function doesn't start a Rex/Box.

     use Data::Dumper;
     task "get_infos", sub {
       my @all_boxes = list_boxes;
       print Dumper(\@all_boxes);
     };

## get\_box($box\_name)

This function tries to gather all information of a Rex/Box. This function also starts a Rex/Box to gather all information of the running system.

     use Data::Dumper;
     task "get_box_info", sub {
       my $data = get_box($box_name);
       print Dumper($data);
     };

## boxes($action, @data)

With this function you can control your boxes. Currently there are 3 actions.

init  
This action can only be used if you're using a YAML file to describe your Rex/Boxes.

     task "prepare_boxes", sub {
       boxes "init";
     };

start  
This action start one or more Rex/Boxes.

     task "start_boxes", sub {
       boxes "start", "box1", "box2";
     };

stop  
This action stop one or more Rex/Boxes.

     task "stop_boxes", sub {
       boxes "stop", "box1", "box2";
     };
