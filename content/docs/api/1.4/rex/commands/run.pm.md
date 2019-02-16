---
title: Run.pm
---

-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [SYNOPSIS](#SYNOPSIS)
-   [EXPORTED FUNCTIONS](#EXPORTED-FUNCTIONS)
    -   [run($command \[, $callback\])](#run-command-callback-)
    -   [run($command\_description, command =&gt; $command, %options)](#run-command_description-command-command-options-)
    -   [can\_run($command)](#can_run-command-)
    -   [sudo](#sudo)

# NAME

Rex::Commands::Run - Execute a remote command

# DESCRIPTION

With this module you can run a command.

# SYNOPSIS

     my $output = run "ls -l";
     sudo "id";

# EXPORTED FUNCTIONS

## run($command \[, $callback\])

## run($command\_description, command =&gt; $command, %options)

This function will execute the given command and returns the output. In scalar context it returns the raw output as is, and in list context it returns the list of output lines. The exit value of the command is stored in the $? variable.

     task "uptime", "server01", sub {
       say run "uptime";
       run "uptime", sub {
         my ($stdout, $stderr) = @_;
         my $server = Rex::get_current_connection()->{server};
         say "[$server] $stdout\n";
       };
     };

Supported options are:

      cwd           => $path
        sets the working directory of the executed command to $path
      only_if       => $condition_command
        executes the command only if $condition_command completes successfully
      unless        => $condition_command
        executes the command unless $condition_command completes successfully
      only_notified => TRUE
        queues the command, to be executed upon notification (see below)
      env           => { var1 => $value1, ..., varN => $valueN }
        sets environment variables in the environment of the command
      timeout       => value
        sets the timeout for the command to be run
      auto_die      => TRUE
        die if the command returns with a non-zero exit code
        it can be set globally via the exec_autodie feature flag
      command       => $command_to_run
        if set, run tries to execute the specified command and the first argument
        becomes an identifier for the run block (e.g. to be triggered with notify)
      creates       => $file_to_create
        tries to create $file_to_create upon execution
        skips execution if the file already exists

Examples:

If you only want to run a command in special cases, you can queue the command and notify it when you want to run it.

     task "prepare", sub {
       run "extract-something",
         command     => "tar -C /foo -xzf /tmp/foo.tgz",
         only_notified => TRUE;

       # some code ...

       notify "run", "extract-something";  # now the command gets executed
     };

If you only want to run a command if another command succeeds or fails, you can use *only\_if* or *unless* option.

     run "some-command",
       only_if => "ps -ef | grep -q httpd";   # only run if httpd is running

     run "some-other-command",
       unless => "ps -ef | grep -q httpd";    # only run if httpd is not running

If you want to set custom environment variables you can do it like this:

     run "my_command",

        env => {
         env_var_1 => "the value for 1",
         env_var_2 => "the value for 2",
       };

If you want to end the command upon receiving a certain output: run "my\_command", end\_if\_matched =&gt; qr/PATTERN/;

## can\_run($command)

This function checks if a command is in the path or is available. You can specify multiple commands, the first command found will be returned.

     task "uptime", sub {
       if( my $cmd = can_run("uptime", "downtime") ) {
         say run $cmd;
       }
     };

## sudo

Run a single command, a code block, or all commands with `sudo`. You need perl to be available on the remote systems to use `sudo`.

Depending on your remote sudo configuration, you may need to define a sudo password with *sudo\_password* first:

     sudo_password 'my_sudo_password'; # hardcoding

Or alternatively, since Rexfile is plain perl, you can read the password from terminal at the start:

     use Term::ReadKey;
     
     print 'I need sudo password: ';
     ReadMode('noecho');
     sudo_password ReadLine(0);
     ReadMode('restore');

Similarly, it is also possible to read it from a secret file, database, etc.

You can turn sudo on globally with:

     sudo TRUE; # run _everything_ with sudo

To run only a specific command with sudo, use :

     say sudo 'id';                # passing a remote command directly
     say sudo { command => 'id' }; # passing anonymous hashref
     
     say sudo { command => 'id', user => 'different' }; # run a single command with sudo as different user
     
     # running a single command with sudo as different user, and `cd` to another directory too
     say sudo { command => 'id', user => 'different', cwd => '/home/different' };

Passing an anonymous *coderef* to `sudo` allows for running the commands in the sub with sudo:

     sudo sub {
         service 'nginx' => 'restart';
         say run 'id';
     };
