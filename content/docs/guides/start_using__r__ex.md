---
title: Howto start using (R)?ex
---

This is a small howto showing the first steps with Rex.

# Basic Architecture

<img src="/public/images/skin/rexify.org/archi.png" width="410" height="272" />Rex is a server orchestration tool that doesn't need an agent on the hosts you want to manage. In fact it uses ssh to execute the given commands.
To use Rex you don't need Perl knowledge at first. Rex uses a simple DSL to describe your servers. Indeed, it is also possible to use Rex from within your shell scripts without using perl at all.
In fact, if you know a little bit perl it won't hurt you.
The starting point of every Rex project is the so called Rexfile. You can think of this file like a Makefile. You can define tasks in this file.
A task is a bunch of related commands. For example installing a package, uploading the configuration file and starting the service. You can also call tasks from other tasks or create rollback scenarios if something went wrong during the execution.

# Requirements

To run Rex you don't need much.

## Central Master Host

You can run Rex from your workstation or on a central master host.
For your central Rex machine (the master) you need at least Perl 5.8. For a better experience we recommend using Perl 5.10.1 and above.
On this host you also need some Perl modules installed. If you're using the provided packages or install Rex via cpanm the dependencies will be installed automatically.

You can install Rex on a Linux host via a simple one-liner. For other systems please read the instructions on the Get Rex page.

    $ curl -L https://get.rexify.org | perl - --sudo -n Rex

This command will install Rex on your system.
We recommend to use our packages from the repository.

## Managed Hosts

On the systems you want to manage you need only two things: a Perl 5 interpreter, and a valid SSH account.

Rex only uses core Perl modules on the remote hosts, but some operating systems (e.g. RHEL/CentOS 7, Fedora 21) might not supply all of them out of the box. In this case you might need to install them first (currently this means the Digest::MD5 module).

You can install this module with `yum install perl-Digest-MD5`.

If you want to run administrative tasks on the remote machines, you obviously would need root or sudo access on them.

# Creating a Rexfile

First we need to create a new folder to store your Rexfile in it.

    $ mkdir -p projects/my-first-rex-project

Now change into this directory and create a file called Rexfile with the following contents:

``` perl
use Rex -feature => ['1.3'];

user "my-user";
password "my-password";

group myservers => "mywebserver", "mymailserver", "myfileserver";

desc "Get the uptime of all servers";
task "uptime", group => "myservers", sub {
   my $output = run "uptime";
   say $output;
};
```

This Example will login as my-user with the password my-password on all the servers in the group myservers and run the command "uptime".
The special first line `use Rex -feature => ['1.3'];` enables all features that are available for version 1.3. If you want to know more about feature flags, please read this page.
Change into the directory where you just created the Rexfile (in a terminal).

    $ cd projects/my-first-rex-project
    $ rex uptime

## Adding a second task

To add a second task, just add the next lines to your Rexfile.

    desc "Start Apache Service";
    task "start_apache", group => "myservers", sub {
        service "apache2" => "start";
    };

This task will start the service apache2 on all the servers in the myservers group.
Display all tasks in a Rexfile
If you want to display all tasks in your Rexfile use the following command.

    $ rex -T
    Tasks
      start_apache                   Start Apache Service
      uptime                         Get the uptime of all servers
    Server Groups
      myservers                       mywebserver, mymailserver, myfileserver

## Authentication

In the previous example we showed you how you can login with a user and a password. But it is also possible to use key authentication.
To use key authentication just define your private and public key inside the Rexfile.

    user "my-user";
    private_key "/home/user/.ssh/id_rsa";
    public_key "/home/user/.ssh/id_rsa.pub";
    key_auth;

It is also possible to use your keys with a passphrase. Just add it to your Rexfile.

    user "my-user";
    private_key "/home/user/.ssh/id_rsa";
    public_key "/home/user/.ssh/id_rsa.pub";
    password "key-passphrase";
    key_auth;

If you don't want to add your passphrase to the Rexfile you can also use ssh-agent. Rex will automatically use it when it is running. Just remove the line key\_auth;.

## Managing Services

If you want to manage services you often need to upload a configuration file and to register the service to start at boot time.
In this example you will learn how to install and configure ntp. You can adapt this example to every other service easily.

    # Rexfile
    use Rex -feature => ['1.3'];

    user "root";
    private_key "/root/.ssh/id_rsa";
    public_key "/root/.ssh/id_rsa.pub";

    group all_servers => "srv[001..150]";

    task "setup_ntp", group => "all_servers", sub {
       # first we will install the package
       pkg "ntpd",
         ensure => "present";

       # then we will upload a configuration file.
       # the configuration file is located in a subdirectory files/etc.
       file "/etc/ntp.conf",
          source    => "files/etc/ntp.conf",
          on_change => sub {
             # we define a on_change hook, so that the ntpd server gets restarted if the file is modified.
             service ntpd => "restart";
          };

       # now we register the service to start at boot time.
       service "ntpd",
         ensure => "started";
    };

That's all.
This task will now install ntpd on your servers, upload a configuration file and start the service.
You don't need to worry about the order of your commands. Rex will always executes your commands from top to bottom.
To read more about [using modules and templates please read this howto](../../docs/guides/using_modules_and_templates.html).
