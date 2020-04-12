---
title: FAQ
---

Here we will maintain a list of frequently asked questions with their answers.

* [Is it called (R)?ex or Rex?](#isitcalledrexorrex)
* [Why does the run command not format the output?](#whydoestheruncommandnotformattheoutput)
* [How can I get the current server from within a task?](#howcanigetthecurrentserverfromwithinatask)
* [How can I pass parameters to a task?](#howcanipassparameterstoatask)
* [How can I run a block of code with one command?](#howcanirunablockofcodewithonecommand)
* [How can I run a local script on the remote?](#howcanirunalocalscriptontheremote)
* [How do I run a local script on the remote under a different user?](#howdoirunalocalscriptontheremoteunderadifferentuser)
* [How do I check the exit status of a remotely run command?](#howdoichecktheexitstatusofaremotelyruncommand)
* [How do I use Rex's built-in logger for ERROR/WARN/INFO/DEBUG messages?](#howdoiuserexsbuilt-inloggerforerrorwarninfodebugmessages)
* [How do I load all my custom modules easily?](#howdoiloadallmycustommoduleseasily)
* [How do I indicate the task failed to run properly?](#howdoiindicatethetaskfailedtorunproperly)

## Is it called (R)?ex or Rex?

Rex stands for **R**emote **ex**ecution. Since automating tasks locally are just as fine as doing the same remotely, (R)?ex is simply a stylized form of _(Remote)? execution_. Both refers to the same thing: the friendly automation framework.

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

Then you can run `mytask` from CLI like this:

    rex -H hostname mytask --parameter1=value1 --parameter2=value2

Or from Rex code either using[run_task](https://metacpan.org/pod/Rex::Commands#run_task):

    ```perl
    run_task 'my_task',
      params => { parameter1 => 'value1', parameter2 => 'value2' };
    ```

or calling the task as a function:

    ```perl
    mytask( { parameter1 => 'value1', parameter2 => 'value2' } );
    ```

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

## How do I load all my custom modules easily?

There are plenty of CPAN modules providing this kind of functionality. For a comprehensive list and overview from some time ago, please read Neil Bowers' article about [CPAN modules that (can) load other modules](http://neilb.org/reviews/module-loading.html).

Since Rex is just Perl, simply use one of them, like [Module::Find](https://metacpan.org/pod/Module::Find) or [Module::Pluggable](https://metacpan.org/pod/Module::Pluggable).

This might affect when modules are loaded (e.g. at compilation time or at runtime), and/or in which order the modules are loaded. If you run into any troubles because of this, please make sure to specify the dependencies of the custom modules correctly.

## How do I indicate the task failed to run properly?

Overall, the same way as in Perl. For example, raising an exception with `die()` in the task body will abort the task, and calling `exit()` will bail out from the whole rex process currently running.
