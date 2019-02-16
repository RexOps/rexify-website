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
    -   [is\_https](#is_https)
    -   [is\_openssh](#is_openssh)
    -   [want\_connect](#want_connect)
    -   [get\_connection\_type](#get_connection_type)
    -   [modify($key, $value)](#modify-key-value-)
    -   [rethink\_connection](#rethink_connection)
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
    -   [get\_sudo\_password](#get_sudo_password)
    -   [parallelism](#parallelism)
    -   [set\_parallelism($count)](#set_parallelism-count-)
    -   [connect($server)](#connect-server-)
    -   [disconnect](#disconnect)
    -   [get\_data](#get_data)
    -   [run($server, %options)](#run-server-options-)
    -   [modify\_task($task, $key =&gt; $value)](#modify_task-task-key-value-)
    -   [is\_task](#is_task)
    -   [get\_tasks](#get_tasks)
    -   [get\_desc](#get_desc)
    -   [exit\_on\_connect\_fail](#exit_on_connect_fail)
    -   [set\_exit\_on\_connect\_fail](#set_exit_on_connect_fail)
    -   [get\_args](#get_args)
    -   [get\_opts](#get_opts)
    -   [set\_args](#set_args)
    -   [set\_opt](#set_opt)
    -   [set\_opts](#set_opts)
    -   [clone](#clone)

# NAME

Rex::Task - The Task Object

# DESCRIPTION

The Task Object. Typically you only need this class if you want to manipulate tasks after their initial creation.

# SYNOPSIS

     use Rex::Task;
     
     # create a new task
     my $task = Rex::Task->new(name => "testtask");
     $task->set_server("remoteserver");
     $task->set_code(sub { say "Hello"; });
     $task->modify("no_ssh", 1);
     
     # retrieve an existing task
     use Rex::TaskList;
     
     my $existing_task = Rex::TaskList->get_task('my_task');

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
       opts => {key1 => val1, key2 => val2, ...},
       args => [arg1, arg2, ...],
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

## is\_https

Returns true (1) if the task gets executed over https protocol.

## is\_openssh

Returns true (1) if the task gets executed with openssh.

## want\_connect

Returns true (1) if the task will establish a connection to a remote system.

## get\_connection\_type

This method tries to guess the right connection type for the task and returns it.

Current return values are below:

-   SSH: connect to the remote server using Net::SSH2

-   OpenSSH: connect to the remote server using Net::OpenSSH

-   Local: runs locally (without any connections)

-   HTTP: uses experimental HTTP connection

-   HTTPS: uses experimental HTTPS connection

-   Fake: populate the connection properties, but do not connect

    So you can use this type to iterate over a list of remote hosts, but don't let rex build a connection. For example if you want to use Sys::Virt or other modules.

## modify($key, $value)

With this method you can modify values of the task.

## rethink\_connection

Deletes current connection object.

## user

Returns the username the task will use.

## set\_user($user)

Set the username of a task.

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

## get\_sudo\_password

Returns the sudo password.

## parallelism

Get the parallelism count of a task.

## set\_parallelism($count)

Set the parallelism of the task.

## connect($server)

Initiate the connection to $server.

## disconnect

Disconnect from the current connection.

## get\_data

Dump task data.

## run($server, %options)

Run the task on `$server`, with `%options`.

## modify\_task($task, $key =&gt; $value)

Modify `$task`, by setting `$key` to `$value`.

## is\_task

Returns true(1) if the passed object is a task.

## get\_tasks

Returns list of tasks.

## get\_desc

Returns description of task.

## exit\_on\_connect\_fail

Returns true if rex should exit on connect failure.

## set\_exit\_on\_connect\_fail

Sets if rex should exit on connect failure.

## get\_args

Returns arguments of task.

## get\_opts

Returns options of task.

## set\_args

Sets arguments for task.

## set\_opt

Sets an option for task.

## set\_opts

Sets options for task.

## clone

Clones a task.
