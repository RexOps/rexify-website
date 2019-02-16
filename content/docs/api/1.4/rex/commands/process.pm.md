---
title: Process.pm
---

-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [SYNOPSIS](#SYNOPSIS)
-   [EXPORTED FUNCTIONS](#EXPORTED-FUNCTIONS)
    -   [kill($pid, $sig)](#kill-pid-sig-)
    -   [killall($name, $sig)](#killall-name-sig-)
    -   [ps](#ps)
    -   [nice($pid, $level)](#nice-pid-level-)

# NAME

Rex::Commands::Process - Process management commands

# DESCRIPTION

With this module you can manage processes. List, Kill, and so on.

Version &lt;= 1.0: All these functions will not be reported.

All these functions are not idempotent.

# SYNOPSIS

     kill $pid;
     killall "apache2";
     nice($pid, $level);

# EXPORTED FUNCTIONS

## kill($pid, $sig)

Will kill the given process id. If $sig is specified it will kill with the given signal.

     task "kill", "server01", sub {
       kill 9931;
       kill 9931, -9;
     };

## killall($name, $sig)

Will kill the given process. If $sig is specified it will kill with the given signal.

     task "kill-apaches", "server01", sub {
       killall "apache2";
       killall "apache2", -9;
     };

## ps

List all processes on a system. Will return all fields of a *ps aux*.

     task "ps", "server01", sub {
       for my $process (ps()) {
        say "command  > " . $process->{"command"};
        say "pid    > " . $process->{"pid"};
        say "cpu-usage> " . $process->{"cpu"};
       }
     };

On most operating systems it is also possible to define custom parameters for ps() function.

     task "ps", "server01", sub {
       my @list = grep { $_->{"ni"} == -5 } ps("command","ni");
     };

This example would contain all processes with a nice of -5.

## nice($pid, $level)

Renice a process identified by $pid with the priority $level.

     task "renice", "server01", sub {
       nice (153, -5);
     };
