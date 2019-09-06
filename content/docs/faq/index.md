---
title: FAQ
---

Here we will maintain a list of frequently asked questions with their answers.

* [Why does the run command not format the output?](#whydoestheruncommandnotformattheoutput)
* [How can I get the current server from within a task?](#howcanigetthecurrentserverfromwithinatask)
* [How can I pass parameters to a task?](#howcanipassparameterstoatask)
* [How can I run a block of code with one command?](#howcanirunablockofcodewithonecommand)
* [How can I run a local script on the remote?](#howcanirunalocalscriptontheremote)
* [How do I run a local script on the remote under a different user?](#howdoirunalocalscriptontheremoteunderadifferentuser)
* [How do I check the exit status of a remotely run command?](#howdoichecktheexitstatusofaremotelyruncommand)
* [How do I use Rex's built-in logger for ERROR/WARN/INFO/DEBUG messages?](#howdoiuserexsbuilt-inloggerforerrorwarninfodebugmessages)

## Why does the run command not format the output?

The run command - called in array context - will return an array.

If you want to print the output to your terminal you have to call it in a scalar context.

    ```perl
    my $output = run "df -h";
    say $output;
    ```

## How can I get the current server from within a task?

    ```perl
    my $current_server = connection->server;
    ```

## How can I pass parameters to a task?

    ```perl
    task 'mytask', sub {
      my $parameters       = shift;
      my $parameter1_value = $parameters->{parameter1};
      my $parameter2_value = $parameters->{parameter2};
    };
    ```

Then you can run mytask from CLI like this:

    rex -H hostname mytask --parameter1=value1 --parameter2=value2

## How can I run a block of code with one command?

You can use the ShellBlock module. This module can be installed by running:

    $ rexify --use Rex::Misc::ShellBlock

Then, you can run your shell code remotely as:

    ```perl
    use Rex::Misc::ShellBlock;
    
    task "myexec", sub {
      shell_block <<EOF;
        echo "hi"
    EOF
    };
    ```

See the linked documentation page for how to use this module with Perl, Python, or other languages.

## How can I run a local script on the remote?

If you have a local script 'files/script', you can run it on the remote using the ShellBlock module referred to in the FAQ above. After you install as pointed out above, you can run the script remotely with the command:

    ```perl
    use Rex::Misc::ShellBlock;
    task "myexec", sub {
      shell_block template('files/script');
    };
    ```

## How do I run a local script on the remote under a different user?

Given the same scenario as above, but with the additional requirement to run the script as a different user, the solution looks like below:

    ```perl
    use Rex::Misc::ShellBlock;
    task "myexec", sub {
      sudo {
        command => sub {
          shell_block template('files/script');
        },
        user => 'root'
      };
    };
    ```

## How do I check the exit status of a remotely run command?

Rex assigns the exit code from the remote invocation of `run` or `shell_block` statements to the `$?` variable.

## How do I use Rex's built-in logger for ERROR/WARN/INFO/DEBUG messages?

    ```perl
    Rex::Logger::info("some message"); # for INFO  (green)
    Rex::Logger::info( "some message", "warn" );  # for WARN  (yellow)
    Rex::Logger::info( "some message", "error" ); # for ERROR (red)
    ```
