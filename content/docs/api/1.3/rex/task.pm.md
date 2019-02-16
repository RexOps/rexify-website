---
title: Task.pm
---

-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [SYNOPSIS](#SYNOPSIS)
-   [METHODS](#METHODS)
    -   [new](#new)
    -   [connection](#connection)
    -   [executor](#executor)
    -   [hidden](#hidden)
    -   [server](#server)
    -   [set\_server(@server)](#set_server-server-)
    -   [delete\_server](#delete_server)
    -   [current\_server](#current_server)
    -   [desc](#desc)
    -   [set\_desc($description)](#set_desc-description-)
    -   [is\_remote](#is_remote)
    -   [is\_local](#is_local)
    -   [is\_http](#is_http)
    -   [want\_connect](#want_connect)
    -   [get\_connection\_type](#get_connection_type)
    -   [modify($key, $value)](#modify-key-value-)
    -   [user](#user)
    -   [set\_user($user)](#set_user-user-)
    -   [password](#password)
    -   [set\_password($password)](#set_password-password-)
    -   [name](#name)
    -   [code](#code)
    -   [set\_code(\\&code\_ref)](#set_code-code_ref-)
    -   [run\_hook($server, $hook)](#run_hook-server-hook-)
    -   [set\_auth($key, $value)](#set_auth-key-value-)
    -   [merge\_auth($server)](#merge_auth-server-)
    -   [parallelism](#parallelism)
    -   [set\_parallelism($count)](#set_parallelism-count-)
    -   [connect($server)](#connect-server-)
    -   [disconnect](#disconnect)
    -   [run($server, %options)](#run-server-options-)
    -   [exit\_on\_connect\_fail()](#exit_on_connect_fail-)

# NAME

Rex::Task - The Task Object

# DESCRIPTION

The Task Object. Typically you only need this class if you want to manipulate tasks after their initial creation.

# SYNOPSIS

     use Rex::Task
     
      my $task = Rex::Task->new(name => "testtask");
      $task->set_server("remoteserver");
      $task->set_code(sub { say "Hello"; });
      $task->modify("no_ssh", 1);

# METHODS

## new

This is the constructor.

      $task = Rex::Task->new(
        func => sub { some_code_here },
        server => [ @server ],
        desc => $description,
        no_ssh => $no_ssh,
        hidden => $hidden,
        auth => {
          user      => $user,
          password   => $password,
          private_key => $private_key,
          public_key  => $public_key,
        },
        before => [sub {}, sub {}, ...],
        after  => [sub {}, sub {}, ...],
        around => [sub {}, sub {}, ...],
        before_task_start => [sub {}, sub {}, ...],
        after_task_finished => [sub {}, sub {}, ...],
        name => $task_name,
        executor => Rex::Interface::Executor->create,
      );

## connection

Returns the current connection object.

## executor

Returns the current executor object.

## hidden

Returns true if the task is hidden. (Should not be displayed on ,,rex -T''.)

## server

Returns the servers on which the task should be executed as an ArrayRef.

## set\_server(@server)

With this method you can set new servers on which the task should be executed on.

## delete\_server

Delete every server registered to the task.

## current\_server

Returns the current server on which the tasks gets executed right now.

## desc

Returns the description of a task.

## set\_desc($description)

Set the description of a task.

## is\_remote

Returns true (1) if the task will be executed remotely.

## is\_local

Returns true (1) if the task gets executed on the local host.

## is\_http

Returns true (1) if the task gets executed over http protocol.

## want\_connect

Returns true (1) if the task will establish a connection to a remote system.

## get\_connection\_type

This method tries to guess the right connection type for the task and returns it.

Current return values are SSH, Fake and Local.

SSH - will create a ssh connection to the remote server

Local - will not create any connections

Fake - will not create any connections. But it populates the connection properties so you can use this type to iterate over a list of remote hosts but don't let rex build a connection. For example if you want to use Sys::Virt or other modules.

## modify($key, $value)

With this method you can modify values of the task.

## user

Returns the current user the task will use.

## set\_user($user)

Set the user of a task.

## password

Returns the password that will be used.

## set\_password($password)

Set the password of the task.

## name

Returns the name of the task.

## code

Returns the code of the task.

## set\_code(\\&code\_ref)

Set the code of the task.

## run\_hook($server, $hook)

This method is used internally to execute the specified hooks.

## set\_auth($key, $value)

Set the authentication of the task.

     $task->set_auth("user", "foo");
     $task->set_auth("password", "bar");

## merge\_auth($server)

Merges the authentication information from $server into the task. Tasks authentication information have precedence.

## parallelism

Get the parallelism count of a task.

## set\_parallelism($count)

Set the parallelism of the task.

## connect($server)

Initiate the connection to $server.

## disconnect

Disconnect from the current connection.

## run($server, %options)

Run the task on $server.

## exit\_on\_connect\_fail()

Returns true if rex should exit on connect failure.
