---
title: User.pm
---

-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [SYNOPSIS](#SYNOPSIS)
-   [EXPORTED FUNCTIONS](#EXPORTED-FUNCTIONS)
    -   [account($name, %option)](#account-name-option-)
    -   [create\_user($user =&gt; {})](#create_user-user-)
    -   [get\_uid($user)](#get_uid-user-)
    -   [get\_user($user)](#get_user-user-)
    -   [user\_groups($user)](#user_groups-user-)
    -   [user\_list()](#user_list-)
    -   [delete\_user($user)](#delete_user-user-)
    -   [lock\_password($user)](#lock_password-user-)
    -   [unlock\_password($user)](#unlock_password-user-)
    -   [create\_group($group, {})](#create_group-group-)
    -   [get\_gid($group)](#get_gid-group-)
    -   [get\_group($group)](#get_group-group-)
    -   [delete\_group($group)](#delete_group-group-)

# NAME

Rex::Commands::User - Manipulate users and groups

# DESCRIPTION

With this module you can manage user and groups.

# SYNOPSIS

     use Rex::Commands::User;
     
     task "create-user", "remoteserver", sub {
       create_user "root",
         uid         => 0,
         home        => '/root',
         comment     => 'Root Account',
         expire      => '2011-05-30',
         groups      => [ 'root', '...' ],
         password    => 'blahblah',
         system      => 1,
         create_home => TRUE,
         ssh_key     => "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQChUw...";
     };

# EXPORTED FUNCTIONS

## account($name, %option)

Manage user account.

     account "krimdomu",
       ensure         => "present",  # default
       uid            => 509,
       home           => '/root',
       comment        => 'User Account',
       expire         => '2011-05-30',
       groups         => [ 'root', '...' ],
       password       => 'blahblah',
       crypt_password => '*', # on Linux, OpenBSD and NetBSD
       system         => 1,
       create_home    => TRUE,
       ssh_key        => "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQChUw...";

There is also a no\_create\_home option similar to create\_home but doing the opposite. If both used, create\_home takes precedence as it the preferred option to specify home directory creation policy.

If none of them are specified, Rex follows the remote system's home creation policy.

The crypt\_password option specifies the encrypted value as found in /etc/shadow; on Linux special values are '\*' and '!' which mean 'disabled password' and 'disabled login' respectively.

## create\_user($user =&gt; {})

Create or update a user.

## get\_uid($user)

Returns the uid of $user.

## get\_user($user)

Returns all information about $user.

## user\_groups($user)

Returns group membership about $user.

## user\_list()

Returns user list via getent passwd.

     task "list_user", "server01", sub {
       for my $user (user_list) {
         print "name: $user / uid: " . get_uid($user) . "\n";
       }
     };

## delete\_user($user)

Delete a user from the system.

     delete_user "trak", {
       delete_home => 1,
       force     => 1,
     };

## lock\_password($user)

Lock the password of a user account. Currently this is only available on Linux (see passwd --lock).

## unlock\_password($user)

Unlock the password of a user account. Currently this is only available on Linux (see passwd --unlock).

## create\_group($group, {})

Create or update a group.

     create_group $group, {
       gid => 1500,
       system => 1,
     };

## get\_gid($group)

Return the group id of $group.

## get\_group($group)

Return information of $group.

     $info = get_group("wheel");

## delete\_group($group)

Delete a group.
