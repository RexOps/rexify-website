---
title: Rex.pm
---

-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [GETTING HELP](#GETTING-HELP)
-   [SYNOPSIS](#SYNOPSIS)
-   [CLASS METHODS](#CLASS-METHODS)
    -   [get\_current\_connection](#get_current_connection)
    -   [is\_ssh](#is_ssh)
    -   [is\_local](#is_local)
    -   [is\_sudo](#is_sudo)
    -   [get\_sftp](#get_sftp)
    -   [connect](#connect)
-   [CONTRIBUTORS](#CONTRIBUTORS)
-   [LICENSE](#LICENSE)

# NAME

Rex - Remote Execution

# DESCRIPTION

(R)?ex is a small script to ease the execution of remote commands. You can write small tasks in a file named *Rexfile*.

You can find examples and howtos on <http://rexify.org/>

# GETTING HELP

-   Web Site: <http://rexify.org/>

-   IRC: irc.freenode.net \#rex

-   Bug Tracker: <https://github.com/RexOps/Rex/issues>

-   Twitter: <http://twitter.com/jfried83>

# SYNOPSIS

     use strict;
     use warnings;

     user "root";
     password "ch4ngem3";

     desc "Show Unix version";
     task "uname", sub {
        say run "uname -a";
     };

     bash# rex -H "server[01..10]" uname

See <span>Rex::Commands</span> for a list of all commands you can use.

# CLASS METHODS

## get\_current\_connection

This function is deprecated since 0.28! See Rex::Commands::connection.

Returns the current connection as a hashRef.

server  
The server name

ssh  
1 if it is a ssh connection, 0 if not.

## is\_ssh

Returns 1 if the current connection is a ssh connection. 0 if not.

## is\_local

Returns 1 if the current connection is local. Otherwise 0.

## is\_sudo

Returns 1 if the current operation is executed within sudo.

## get\_sftp

Returns the sftp object for the current ssh connection.

## connect

Use this function to create a connection if you use Rex as a library.

     use Rex;
     use Rex::Commands::Run;
     use Rex::Commands::Fs;

     Rex::connect(
       server    => "remotehost",
       user      => "root",
       password   => "f00b4r",
       private_key => "/path/to/private/key/file",
       public_key  => "/path/to/public/key/file",
     );

     if(is_file("/foo/bar")) {
       print "Do something...\n";
     }

     my $output = run("uptime");

# CONTRIBUTORS

Many thanks to the contributors for their work. Please see [CONTRIBUTORS](https://github.com/RexOps/Rex/blob/master/CONTRIBUTORS) file for a complete list.

# LICENSE

Rex is a free software, licensed under: The Apache License, Version 2.0, January 2004
