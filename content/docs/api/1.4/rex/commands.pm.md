-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [SYNOPSIS](#SYNOPSIS)
-   [COMMANDLIST](#COMMANDLIST)
-   [EXPORTED FUNCTIONS](#EXPORTED-FUNCTIONS)
    -   [no\_ssh(\[$task\])](#no_ssh-task-)
    -   [task($name \[, @servers\], $funcref)](#task-name-servers-funcref-)
    -   [desc($description)](#desc-description-)
    -   [group($name, @servers)](#group-name-servers-)
    -   [batch($name, @tasks)](#batch-name-tasks-)
    -   [user($user)](#user-user-)
    -   [password($password)](#password-password-)
    -   [auth(for =&gt; $entity, %data)](#auth-for-entity-data-)
    -   [port($port)](#port-port-)
    -   [sudo\_password($password)](#sudo_password-password-)
    -   [timeout($seconds)](#timeout-seconds-)
    -   [max\_connect\_retries($count)](#max_connect_retries-count-)
    -   [get\_random($count, @chars)](#get_random-count-chars-)
    -   [do\_task($task)](#do_task-task-)
    -   [run\_task($task\_name, %option)](#run_task-task_name-option-)
    -   [run\_batch($batch\_name, %option)](#run_batch-batch_name-option-)
    -   [public\_key($key)](#public_key-key-)
    -   [private\_key($key)](#private_key-key-)
    -   [pass\_auth](#pass_auth)
    -   [key\_auth](#key_auth)
    -   [krb5\_auth](#krb5_auth)
    -   [parallelism($count)](#parallelism-count-)
    -   [proxy\_command($cmd)](#proxy_command-cmd-)
    -   [set\_distributor($distributor)](#set_distributor-distributor-)
    -   [template\_function(sub { ... })](#template_function-sub-...-)
    -   [logging](#logging)
    -   [needs($package \[, @tasks\])](#needs-package-tasks-)
    -   [include Module::Name](#include-Module::Name)
    -   [environment($name =&gt; $code)](#environment-name-code-)
    -   [LOCAL(&)](#LOCAL-)
    -   [path(@path)](#path-path-)
    -   [set($key, $value)](#set-key-value-)
    -   [get($key, $value)](#get-key-value-)
    -   [before($task =&gt; sub {})](#before-task-sub-)
    -   [after($task =&gt; sub {})](#after-task-sub-)
    -   [around($task =&gt; sub {})](#around-task-sub-)
    -   [before\_task\_start($task =&gt; sub {})](#before_task_start-task-sub-)
    -   [after\_task\_finished($task =&gt; sub {})](#after_task_finished-task-sub-)
    -   [logformat($format)](#logformat-format-)
    -   [connection](#connection)
    -   [cache](#cache)
    -   [profiler](#profiler)
    -   [report($switch, $type)](#report-switch-type-)
    -   [source\_global\_profile(0|1)](#source_global_profile-0-1-)
    -   [last\_command\_output](#last_command_output)
    -   [case($compare, $option)](#case-compare-option-)
    -   [set\_executor\_for($type, $executor)](#set_executor_for-type-executor-)
    -   [tmp\_dir($tmp\_dir)](#tmp_dir-tmp_dir-)
    -   [inspect($varRef)](#inspect-varRef-)
    -   [sayformat($format)](#sayformat-format-)

# NAME

Rex::Commands - All the basic commands

# DESCRIPTION

This module is the core commands module.

# SYNOPSIS

     desc "Task description";

     task "taskname", sub { ... };
     task "taskname", "server1", ..., "server20", sub { ... };

     group "group" => "server1", "server2", ...;

     user "user";

     password "password";

     environment live => sub {
       user "root";
       password "foobar";
       pass_auth;
       group frontend => "www01", "www02";
     };

# COMMANDLIST

-   Augeas config file management library <span>Rex::Commands::Augeas</span>

-   Cloud Management <span>Rex::Commands::Cloud</span>

-   Cron Management <span>Rex::Commands::Cron</span>

-   Database Commands <span>Rex::Commands::DB</span>

-   SCP Up- and Download <span>Rex::Commands::Upload</span>, <span>Rex::Commands::Download</span>

-   File Manipulation <span>Rex::Commands::File</span>

-   Filesystem Manipulation <span>Rex::Commands::Fs</span>

-   Information Gathering <span>Rex::Commands::Gather</span>

-   Manipulation of /etc/hosts <span>Rex::Commands::Host</span>

-   Get an inventory of your Hardware <span>Rex::Commands::Inventory</span>

-   Manage your iptables rules <span>Rex::Commands::Iptables</span>

-   Kernel Commands <span>Rex::Commands::Kernel</span>

-   LVM Commands <span>Rex::Commands::LVM</span>

-   MD5 checksums <span>Rex::Commands::MD5</span>

-   Network commands <span>Rex::Commands::Network</span>

-   Notify resources to execute <span>Rex::Commands::Notify</span>

-   Package Commands <span>Rex::Commands::Pkg</span>

-   Partition your storage device(s) <span>Rex::Commands::Partition</span>

-   Configure packages (via debconf) <span>Rex::Commands::PkgConf</span>

-   Process Management <span>Rex::Commands::Process</span>

-   Rsync Files <span>Rex::Commands::Rsync</span>

-   Run Remote Commands <span>Rex::Commands::Run</span>

-   Source control via Subversion/Git <span>Rex::Commands::SCM</span>

-   Manage System Services (sysvinit) <span>Rex::Commands::Service</span>

-   Simple TCP/alive checks <span>Rex::Commands::SimpleCheck</span>

-   Sync directories <span>Rex::Commands::Sync</span>

-   Sysctl Commands <span>Rex::Commands::Sysctl</span>

-   Live Tail files <span>Rex::Commands::Tail</span>

-   Upload local file to remote server <span>Rex::Commands::Upload</span>

-   Manage user and group accounts <span>Rex::Commands::User</span>

-   Manage your virtual environments <span>Rex::Commands::Virtualization</span>

# EXPORTED FUNCTIONS

## no\_ssh(\[$task\])

Disable ssh for all tasks or a specified task.

If you want to disable ssh connection for your complete tasks (for example if you only want to use libVirt) put this in the main section of your Rexfile.

     no_ssh;

If you want to disable ssh connection for a given task, put *no\_ssh* in front of the task definition.

     no_ssh task "mytask", "myserver", sub {
       say "Do something without a ssh connection";
     };

## task($name \[, @servers\], $funcref)

This function will create a new task.

Create a local task (a server independent task)  
     task "mytask", sub {
       say "Do something";
     };

If you call this task with (R)?ex it will run on your local machine. You can explicit run this task on other machines if you specify the *-H* command line parameter.

Create a server bound task.  
     task "mytask", "server1", sub {
       say "Do something";
     };

You can also specify more than one server.

     task "mytask", "server1", "server2", "server3", sub {
       say "Do something";
     };

Or you can use some expressions to define more than one server.

     task "mytask", "server[1..3]", sub {
       say "Do something";
     };

If you want, you can overwrite the servers with the *-H* command line parameter.

Create a group bound task.  
You can define server groups with the *group* function.

     group "allserver" => "server[1..3]", "workstation[1..10]";

     task "mytask", group => "allserver", sub {
       say "Do something";
     };

## desc($description)

Set the description of a task.

     desc "This is a task description of the following task";
     task "mytask", sub {
       say "Do something";
     }

## group($name, @servers)

With this function you can group servers, so that you don't need to write too much ;-)

     group "servergroup", "www1", "www2", "www3", "memcache01", "memcache02", "memcache03";

Or with the expression syntax:

     group "servergroup", "www[1..3]", "memcache[01..03]";

You can also specify server options after a server name with a hash reference:

     group "servergroup", "www1" => { user => "other" }, "www2";

These expressions are allowed:

-   \\d+..\\d+ (range)

    The first number is the start and the second number is the end for numbering the servers.

         group "name", "www[1..3]"; # www1, www2, www3

-   \\d+..\\d+/\\d+ (range with step)

    Just like the range notation, but with an additional "step" defined. If step is omitted, it defaults to 1 (i.e. it behaves like a simple range expression).

         group "name", "www[1..5/2]";      # www1, www3, www5
         group "name", "www[111..133/11]"; # www111, www122, www133

-   \\d+,\\d+,\\d+ (list)

    With this variant you can define fixed values.

         group "name", "www[1,3,7,01]"; # www1, www3, www7, www01

-   Mixed list, range and range with step

    You can mix the three variants above

         www[1..3,5,9..21/3]; # www1, www2, www3, www5, www9, www12, www15, www18, www21

## batch($name, @tasks)

With the batch function you can call tasks in a batch.

     batch "name", "task1", "task2", "task3";

And call it with the *-b* console parameter. *rex -b name*

## user($user)

Set the user for the ssh connection.

## password($password)

Set the password for the ssh connection (or for the private key file).

## auth(for =&gt; $entity, %data)

With this function you can modify/set special authentication parameters for tasks and groups. If you want to modify a group's authentication you first have to create it. (Place the auth command after the group.)

If you want to set special login information for a group you have to activate that feature first.

     use Rex -feature => 0.31; # activate setting auth for a group

     # auth for groups
     
     group frontends => "web[01..10]";
     group backends => "be[01..05]";
     
     auth for => "frontends" =>
                user => "root",
                password => "foobar";
     
     auth for => "backends" =>
                user => "admin",
                private_key => "/path/to/id_rsa",
                public_key => "/path/to/id_rsa.pub",
                sudo => TRUE;

     # auth for tasks
     
     task "prepare", group => ["frontends", "backends"], sub {
       # do something
     };
     
     auth for => "prepare" =>
                user => "root";

     # auth for multiple tasks with regular expression
     
     task "step_1", sub {
      # do something
     };
     
     task "step_2", sub {
      # do something
     };
     
     auth for => qr/step/ =>
       user     => $user,
       password => $password;

     # fallback auth
     auth fallback => {
       user        => "fallback_user1",
       password    => "fallback_pw1",
       public_key  => "",
       private_key => "",
     }, {
       user        => "fallback_user2",
       password    => "fallback_pw2",
       public_key  => "keys/public.key",
       private_key => "keys/private.key",
       sudo        => TRUE,
     };

## port($port)

Set the port where the ssh server is listening.

## sudo\_password($password)

Set the password for the sudo command.

## timeout($seconds)

Set the timeout for the ssh connection and other network related stuff.

## max\_connect\_retries($count)

Set the maximum number of connection retries.

## get\_random($count, @chars)

Returns a random string of $count characters on the basis of @chars.

     my $rnd = get_random(8, 'a' .. 'z');

## do\_task($task)

Call $task from another task. It will establish a new connection to the server defined in $task and then execute $task there.

     task "task1", "server1", sub {
       say "Running on server1";
       do_task "task2";
     };

     task "task2", "server2", sub {
       say "Running on server2";
     };

You may also use an arrayRef for $task if you want to call multiple tasks.

     do_task [ qw/task1 task2 task3/ ];

## run\_task($task\_name, %option)

Run a task on a given host.

     my $return = run_task "taskname", on => "192.168.3.56";

Do something on server5 if memory is less than 100 MB free on server3.

     task "prepare", "server5", sub {
       my $free_mem = run_task "get_free_mem", on => "server3";
       if($free_mem < 100) {
         say "Less than 100 MB free mem on server3";
         # create a new server instance on server5 to unload server3
       }
     };

     task "get_free_mem", sub {
        return memory->{free};
     };

If called without a hostname the task is run localy.

     # this task will run on server5
     task "prepare", "server5", sub {
       # this will call task check_something. but this task will run on localhost.
       my $check = run_task "check_something";
     }

     task "check_something", "server4", sub {
       return "foo";
     };

If you want to add custom parameters for the task you can do it this way.

     task "prepare", "server5", sub {
      run_task "check_something", on => "foo", params => { param1 => "value1", param2 => "value2" };
     };

## run\_batch($batch\_name, %option)

Run a batch on a given host.

     my @return = run_batch "batchname", on => "192.168.3.56";

It calls internally run\_task, and passes it any option given.

## public\_key($key)

Set the public key.

## private\_key($key)

Set the private key.

## pass\_auth

If you want to use password authentication, then you need to call *pass\_auth*.

     user "root";
     password "root";

     pass_auth;

## key\_auth

If you want to use pubkey authentication, then you need to call *key\_auth*.

     user "bob";
     private_key "/home/bob/.ssh/id_rsa"; # passphrase-less key
     public_key "/home/bob/.ssh/id_rsa.pub";

     key_auth;

## krb5\_auth

If you want to use kerberos authentication, then you need to call *krb5\_auth*. This authentication mechanism is only available if you use Net::OpenSSH.

     set connection => "OpenSSH";
     user "root";
     krb5_auth;

## parallelism($count)

Will execute the tasks in parallel on the given servers. $count is the thread count to be used:

     parallelism '2'; # set parallelism to 2

Alternatively, the following notation can be used to set thread count more dynamically:

     parallelism 'max';     # set parallelism to the number of servers a task is asked to run on
     parallelism 'max/3';   # set parallelism to 1/3 of the number of servers
     parallelism 'max 10%'; # set parallelism to 10% of the number of servers

If an unrecognized value is passed, or the calculated thread count would be less than 1, Rex falls back to use a single thread.

## proxy\_command($cmd)

Set a proxy command to use for the connection. This is only possible with OpenSSH connection method.

     set connection => "OpenSSH";
     proxy_command "ssh user@jumphost nc %h %p 2>/dev/null";

## set\_distributor($distributor)

This sets the task distribution module. Default is "Base".

Possible values are: Base, Gearman, Parallel\_ForkManager

## template\_function(sub { ... })

This function sets the template processing function. So it is possible to change the template engine. For example to Template::Toolkit.

## logging

With this function you can define the logging behaviour of (R)?ex.

Logging to a file  
     logging to_file => "rex.log";

Logging to syslog  
     logging to_syslog => $facility;

## needs($package \[, @tasks\])

With *needs* you can define dependencies between tasks. The "needed" tasks will be called with the same server configuration as the calling task.

*needs* will not execute before, around and after hooks.

Depend on all tasks in a given package.  
Depend on all tasks in the package MyPkg. All tasks will be called with the server *server1*.

     task "mytask", "server1", sub {
       needs MyPkg;
     };

Depend on a single task in a given package.  
Depend on the *uname* task in the package MyPkg. The *uname* task will be called with the server *server1*.

     task "mytask", "server1", sub {
       needs MyPkg "uname";
     };

To call tasks defined in the Rexfile from within a module  
     task "mytask", "server1", sub {
       needs main "uname";
     };

## include Module::Name

Include a module without registering its tasks.

      include qw/
        Module::One
        Module::Two
      /;

## environment($name =&gt; $code)

Define an environment. With environments one can use the same task for different hosts. For example if you want to use the same task on your integration-, test- and production servers.

     # define default user/password
     user "root";
     password "foobar";
     pass_auth;

     # define default frontend group containing only testwww01.
     group frontend => "testwww01";

     # define live environment, with different user/password
     # and a frontend server group containing www01, www02 and www03.
     environment live => sub {
       user "root";
       password "livefoo";
       pass_auth;

       group frontend => "www01", "www02", "www03";
     };

     # define stage environment with default user and password. but with
     # a own frontend group containing only stagewww01.
     environment stage => sub {
       group frontend => "stagewww01";
     };

     task "prepare", group => "frontend", sub {
        say run "hostname";
     };

Calling this task *rex prepare* will execute on testwww01. Calling this task with *rex -E live prepare* will execute on www01, www02, www03. Calling this task *rex -E stage prepare* will execute on stagewww01.

You can call the function within a task to get the current environment.

     task "prepare", group => "frontend", sub {
       if(environment() eq "dev") {
         say "i'm in the dev environment";
       }
     };

If no *-E* option is passed on the command line, the default environment (named 'default') will be used.

## LOCAL(&)

With the LOCAL function you can do local commands within a task that is defined to work on remote servers.

     task "mytask", "server1", "server2", sub {
        # this will call 'uptime' on the servers 'server1' and 'server2'
        say run "uptime";

        # this will call 'uptime' on the local machine.
        LOCAL {
          say run "uptime";
        };
     };

## path(@path)

Set the execution path for all commands.

     path "/bin", "/sbin", "/usr/bin", "/usr/sbin", "/usr/pkg/bin", "/usr/pkg/sbin";

## set($key, $value)

Set a configuration parameter. These variables can be used in templates as well.

     set database => "db01";

     task "prepare", sub {
       my $db = get "database";
     };

Or in a template

     DB: <%= $::database %>

The following list of configuration parameters are Rex specific:

## get($key, $value)

Get a configuration parameter.

     set database => "db01";

     task "prepare", sub {
       my $db = get "database";
     };

Or in a template

     DB: <%= $::database %>

## before($task =&gt; sub {})

Run code before executing the specified task. The special taskname 'ALL' can be used to run code before all tasks. If called repeatedly, each sub will be appended to a list of 'before' functions.

In this hook you can overwrite the server to which the task will connect to. The second argument is a reference to the server object that will be used for the connection.

Note: must come after the definition of the specified task

     before mytask => sub {
      my ($server, $server_ref, $cli_args) = @_;
      run "vzctl start vm$server";
     };

## after($task =&gt; sub {})

Run code after the task is finished. The special taskname 'ALL' can be used to run code after all tasks. If called repeatedly, each sub will be appended to a list of 'after' functions.

Note: must come after the definition of the specified task

     after mytask => sub {
      my ($server, $failed, $cli_args) = @_;
      if($failed) { say "Connection to $server failed."; }

      run "vzctl stop vm$server";
     };

## around($task =&gt; sub {})

Run code before and after the task is finished. The special taskname 'ALL' can be used to run code around all tasks. If called repeatedly, each sub will be appended to a list of 'around' functions.

In this hook you can overwrite the server to which the task will connect to. The second argument is a reference to the server object that will be used for the connection.

Note: must come after the definition of the specified task

     around mytask => sub {
      my ($server, $server_ref, $cli_args, $position) = @_;

      unless($position) {
        say "Before Task\n";
      }
      else {
        say "After Task\n";
      }
     };

## before\_task\_start($task =&gt; sub {})

Run code before executing the specified task. This gets executed only once for a task. The special taskname 'ALL' can be used to run code before all tasks. If called repeatedly, each sub will be appended to a list of 'before\_task\_start' functions.

Note: must come after the definition of the specified task

     before_task_start mytask => sub {
       # do some things
     };

## after\_task\_finished($task =&gt; sub {})

Run code after the task is finished (and after the ssh connection is terminated). This gets executed only once for a task. The special taskname 'ALL' can be used to run code before all tasks. If called repeatedly, each sub will be appended to a list of 'after\_task\_finished' functions.

Note: must come after the definition of the specified task

     after_task_finished mytask => sub {
       # do some things
     };

## logformat($format)

You can define the logging format with the following parameters.

%D - Appends the current date yyyy-mm-dd HH:mm:ss

%h - The target host

%p - The pid of the running process

%l - Loglevel (INFO or DEBUG)

%s - The Logstring

Default is: \[%D\] %l - %s

## connection

This function returns the current connection object.

     task "foo", group => "baz", sub {
       say "Current Server: " . connection->server;
     };

## cache

This function returns the current cache object.

## profiler

Returns the profiler object for the current connection.

## report($switch, $type)

This function will initialize the reporting.

     report -on => "YAML";

## source\_global\_profile(0|1)

If this option is set, every run() command will first source /etc/profile before getting executed.

## last\_command\_output

This function returns the output of the last "run" command.

On a debian system this example will return the output of *apt-get install foobar*.

     task "mytask", "myserver", sub {
       install "foobar";
       say last_command_output();
     };

## case($compare, $option)

This is a function to compare a string with some given options.

     task "mytask", "myserver", sub {
       my $ntp_service = case operating_sytem, {
                     Debian  => "ntp",
                     default => "ntpd",
                   };

       my $ntp_service = case operating_sytem, {
                     qr{debian}i => "ntp",
                     default    => "ntpd",
                   };

       my $ntp_service = case operating_sytem, {
                     qr{debian}i => "ntp",
                     default    => sub { return "foo"; },
                   };
     };

## set\_executor\_for($type, $executor)

Set the executor for a special type. This is primary used for the upload\_and\_run helper function.

     set_executor_for perl => "/opt/local/bin/perl";

## tmp\_dir($tmp\_dir)

Set the tmp directory on the remote host to store temporary files.

## inspect($varRef)

This function dumps the contents of a variable to STDOUT.

task "mytask", "myserver", sub { my $myvar = { name =&gt; "foo", sys =&gt; "bar", };

      inspect $myvar;
    };

## sayformat($format)

You can define the format of the say() function.

%D - The current date yyyy-mm-dd HH:mm:ss

%h - The target host

%p - The pid of the running process

%s - The Logstring

You can also define the following values:

default - the default behaviour.

asis - will print every single parameter in its own line. This is useful if you want to print the output of a command.
