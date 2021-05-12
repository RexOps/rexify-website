---
title: (R)?ex, the friendly automation framework
date: 2019-12-12
data:
  root: 1
---

## Puts _you_ in charge

Rex acknowledges that instead of silver bullets, there is more than one way to manage it.

It's friendly to any combinations of local and remote execution, push and pull style of management, or imperative and declarative approach.
Instead of forcing any specific model on you, it trusts you to be in the best position to decide what to automate and how, allowing you to build the automation tool _your_ situation requires.

## Easy to get on board

Automate what you are doing today, and add more tomorrow.

Rex runs locally, even if managing remotes via SSH. This means it's instantly usable, without big rollout processes or anyone else to convince, making it ideal and friendly for incremental automation.

<a class="btn" href="/docs/guides/start_using__r__ex.html">Get started &raquo;</a>

## It's just Perl

Perl is a battle-tested, mature language, and Rex code is just Perl code.

This means whenever you reach the limitations of the built-in Rex features, a powerful programming language and module ecosystem is always at your fingertips to seamlessly extend it with modules from [CPAN](https://metacpan.org) or with your own code.

As a bonus, you can also use the usual well-established tools and workflows, like IDE integration for syntax highlighting, linting and formatting, or authoring and publishing [Rex modules on CPAN](https://metacpan.org/search?q=rex).

With the use of [Inline](https://metacpan.org/pod/Inline) and [FFI::Platypus](https://metacpan.org/pod/FFI::Platypus) modules, it's friendly to code written in other languages too. So after all, it's not just Perl.

<a class="btn" href="/docs/guides/just_enough_perl_for_rex.html">Just enough Perl for Rex &raquo;</a>

## Open source

We believe in the idea of open source. So Rex, and all its parts are released under the Apache 2.0 license. You're invited to join the community to make Rex better and better.

<a class="btn" href="/care/help__r__ex.html">View details &raquo;</a>

## Show me the code!

### Uptime?

This command line example will execute `uptime` on all the given hosts (`frontend01`, `frontend02`, ...):

    $ rex -H "frontend[01..05]" -e "say run 'uptime'"

The same, but with a Rexfile

    ```perl
    use Rex -feature => ['1.4'];
    
    desc 'Get uptime';
    task 'uptime', 'frontend[01..05]', sub {
        say run 'uptime';
    };
    ```

Now you can run your task with this command:

    $ rex uptime

## Keep your configuration in sync

This example will install the Apache web server on 5 machines and keep their configuration in sync. If the deployed configuration file changes, it will automatically reload the service.

    ```perl
    use Rex -feature => ['1.4'];
    
    user 'root';
    group frontend => 'frontend[01..05]';
    
    desc 'Prepare frontend server';
    task 'prepare',
      group => 'frontend',
      sub {
        pkg 'apache2', ensure => 'present';
    
        service 'apache2', ensure => 'started';
      };
    
    desc 'Keep configuration in sync';
    task 'configure',
      group => 'frontend',
      sub {
        prepare();
    
        file '/etc/apache2/apache2.conf',
          source    => 'files/etc/apache2/apache2.conf',
          on_change => sub { service apache2 => 'reload'; };
      };
    ```

### Need to use sudo?

You can also run everything with sudo. Just replace the authentication information with the following:

    ```perl
    user 'ubuntu';
    sudo TRUE;
    sudo_password 'mysudopw';
    ```
