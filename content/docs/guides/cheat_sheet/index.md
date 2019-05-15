---
title: Cheat Sheet
---

## Executing a command and parsing its output

### run($command, %options)

Run a remote command and returns its output.

#### Options

- cwd - Work directory for the command.
- only\_if - Executes the command only if the condition completes successfully.
- unless - Executes the command only unless the condition completes successfully.
- only\_notified - queues the command, to be executed upon notification.
- env - sets environment variables for the command.
- timeout - try to terminate the command after the given amount of seconds.
- auto\_die - die if the command returns with a non-zero exit code.
- command - the command that should be executed.
- creates - If the file given with this option already exists, the command won't be executed.

#### Example to just run a command if a file doesn't exists

    run "/tmp/install_service.sh",
      creates => "/opt/myservice/conf.xml";

#### Example to run a command and get its output

    my @output_lines = run "df -h";

## Installing and configuring a service

The most used functions in configuration management is installing/managing services and managing configuration files. In Rex you can do this with the file, pkg and service functions.

### file($remote\_file, %options)

Manage files on remote systems.

#### Options

- ensure - Defines the state of the file. Valid parameters are present, absent, directory.
- source - The local file that should be uploaded to the remote server.
- content - Set the content directly. Can be used together with the template() function.
- owner - The owner of the file.
- group - The group the file should belong to.
- mode - The file system privileges the file should have.
- no\_overwrite - If set to TRUE the file won't be overwritten if the file already exists.
- on\_change - A callback function that gets called when the file state changed. (For example if the file content was modified).

        file "/etc/ntpd.conf",
          ensure => "present",
          source => "files/ntpd.conf",
          owner  => "root",
          group  => "root",
          mode   => 644,
          on_change => sub {
            service ntpd => "restart";
          };

### pkg($name, %options)

Install a package on the remote system.

#### Options

- ensure - Defines the state of the package. Valid parameters are latest, present, absent or the version that should be enforced.
- on\_change - A called function that gets called when the package state changed. (For example when it was updated)

        pkg "ntpd",
          ensure => "latest",
          on_change => sub {
            service ntpd => "restart";
          };

### service

Manage the state of a service.

This function can be called as a resource or as a normal function to directly stop/start/restart/... services.

#### Options (for calling as a resource)

- ensure - Defines the state of the service. Valid parameters are started, stopped.
- start - Custom command to start the service.
- stop - Custom command to stop the service.
- status - Custom command to get the status of a service.
- restart - Custom command to restart a service.
- reload - Custom command to reload a service.

#### Example for calling as resource

    service "nptd",
      ensure => "started";

#### Example for calling as function

    service ntpd => "restart";

## Managing Cron

### Manage cron jobs.

cron\_entry($entry\_name, %options)

#### Options

- ensure - Defines the state of the cron entry. Valid parameters are present, absent.
- command - The command to run.
- minute - The minute when to run the job.
- hour - The hour when to run the job.
- month - The month when to run the job.
- day\_of\_week
- day\_of\_month
- user - The user for the cron job.
- on\_change - A callback function that gets called when the cron entry state changed.

        cron_entry "run-rkhunter",
          command => "rkhunter --cronjob",
          minute  => 5,
          hour    => 1;

## Managing users and groups

Manage local user database.

### account($user\_name, %options)

Manage user accounts.

#### Options

- ensure - Defines the state of the account. Valid parameters are present, absent.
- uid - The user id.
- groups - The groups the user should be member of. The first group is the primary.
- home - The home directory.
- expire - Date when the account will expire. Format: YYYY-MM-DD
- password - Cleartext password for the user.
- crypt\_password - Crypted password for the user. Available on Linux, OpenBSD and NetBSD.
- system - Create a system user.
- create\_home - If the home directory should be created. Valid parameters are TRUE, FALSE.
- ssh\_key - Add ssh key to authorized\_keys.
- comment

        account "krimdomu",
           ensure         => "present",  # default
           uid            => 509,
           home           => '/home/krimdomu',
           comment        => 'User Account',
           expire         => '2011-05-30',
           groups         => [ 'users', 'wheel' ],
           password       => 'blahblah',
           create_home    => TRUE,
           ssh_key        => "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQChUw...";

### group($group\_name, %options)

Manage groups.

#### Options

- ensure - Defines the state of the group. Valid parameters are present, absent.
- gid - The group id.
- system - Create a system group.

        group "users",
          ensure => "present";
