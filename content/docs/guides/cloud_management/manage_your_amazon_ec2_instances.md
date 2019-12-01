---
title: Manage your Amazon EC2 instances
---

## Starting Point

In this howto i will show you how to create and manage your Amazon EC2 instances.

## Preparation

-   Register at http://aws.amazon.com/de/
-   Get your AccessKey and your Secret AccessKey
-   Create a key-pair and save it to your disk
-   Create a public key out of your just downloaded private key. You can do this with ssh-keygen -y -f your-aws-private-key.pem

## Creating a Rexfile

At first you need to create a Rexfile in a directory of your choice.

    $ mkdir amazon
    $ cd amazon
    $ touch Rexfile

Open the Rexfile in your preferred editor.

Insert the following code in your new Rexfile.

    ```perl
    use Rex -feature => ['1.0'];
    use Rex::Commands::Cloud;
    
    user "root";
    public_key "/path/to/your/just/created/amazon-public.key";
    private_key "/path/to/your/just/downloaded/amazon-private-key.pem";
    
    my $access_key        = "your-access-key";
    my $secret_access_key = "your-secret-key";
    
    cloud_service "Amazon";
    cloud_auth "$access_key", "$secret_access_key";
    cloud_region "ec2.eu-west-1.amazonaws.com";
    
    task "create", sub {
        cloud_instance create => {
            image_id => "ami-02103876",
            name     => "static01",
            key      => "dev-test",
        };
    };
    ```

This task create a new Amazon EC2 instance with no EBS block device.

### Create an instance with an EBS block volume

Sometimes you need an instance with a persistent storage volume. To achieve this your can use an EBS block volume.

    ```perl
    task "create", sub {
        my $vol_id = cloud_volume create => { size => 1, zone => "eu-west-1a", };
        cloud_instance create => {
            image_id => "ami-02103876",
            name     => "static01",
            key      => "dev-test",
            volume   => $vol_id,
            zone     => "eu-west-1a",
        };
    };
    ```

### Listing Regions and zones

To get a list of all regions and zone you can use the following functions.

    ```perl
    task "list", sub {
        print Dumper get_cloud_regions;
        print Dumper get_cloud_availability_zones;
    };
    ```

### List your instances

To get a list of all your instances and volumes you can use these functions.

    ```perl
    task "list", sub {
        print Dumper cloud_instance_list;
        print Dumper cloud_volume_list;
    };
    ```

### Destroy your instances / volumes

If you don't need your instances or volumes anymore, you can just destroy them.

    ```perl
    task "destroy", sub {
        cloud_volume delete      => "$volume_id";
        cloud_instance terminate => "$instance_id";
    };
    ```

### Put all your EC2 instances in a host group

If you have many instances you can easily add them all into a hostgroup.

    ```perl
    group ec2 => get_cloud_instances_as_group();
    ```

### Installing some Software and run Rex

Now we need to add some software to our fresh EC2 instance.

    ```perl
    task "prepare",
      group => "ec2",
      sub {
        run "apt-get update";
        install package => "apache2";
    
        service apache2 => "ensure", "started";
    
        # deploy your webapp, see Rex::Apache::Deploy for more information.
        deploy "my-site.tar.gz";
    
        # or upload some files
        file "/etc/passwd", source => "/etc/passwd";
    
        # do what ever you want
        use Rex::Commands::Iptables;
        close_port "all";
      };
    ```

Now you can run Rex to create the instance and prepare the system for use.

    $ rex create prepare
    [2011-08-06 10:25:58] (5783) - INFO - Running task: create
    [2011-08-06 10:26:38] (5783) - INFO - Running task: prepare
    [2011-08-06 10:26:38] (5801) - INFO - Connecting to 46.51.135.11 (root)
    [2011-08-06 10:27:14] (5801) - INFO - Installing apache2.
    [2011-08-06 10:27:30] (5801) - INFO - Uploadling files/index.html -> /var/www/index.html
