For maintainable and reusable code it is important to start with the right infrastructure choices and tools. In this chapter you will learn how to setup and design your project to achieve this.

You can find the code of this chapter on github.

-   The service (example frontend service)
-   An example basic os module to configure the basics
-   An example ntp module

## Building services out of blocks with Rex

If you have a large environment with multiple services and a complex architecture it is important to design your code in a way that you can reuse most parts of it. To achieve this you need to follow some simple rules.

-   Use a source control system like git.
-   Build modules for every part of your architecture. A module should be **generic** and should **not contain** any project specific logic or configuration. For example a module to manage apache or ntp.
-   Build services to tie the modules together. Services should hold **all the project specific information** need to build it.
-   The code of every module and every service should be in a separate code repository. With this it is easier to manage your infrastructure. You can create dependencies between services and modules on a branch level.
-   Use a CMDB to separate configuration from code.

### Source Control System

Currently Rex supports only \*git\* for module and service repositories. So in this example i will use git.

To manage your git repositories i suggest some tool like Gitprep or Gitlab

### Modules

As mentioned above, you should separate your code. For better readability, usability and maintainability of your code this is important.

Modules must be generic. The modules are a bit like lego blocks. You can use lego blocks to build houses, ships, airplanes and much more. But the blocks are always the same.

### Services

Services are a collection of modules. A service describe the system you want to build out of your module blocks.

### CMDB

Rex has a default CMDB build upon YAML files. Store all the service relevant configuration options inside your YAML file. If you do this you can be sure that your code will work even if you change something in the CMDB.

## Example frontend service

This is an example rex service.

### meta.yml - Define dependencies

In the **meta.yml** file you can define some service information. The most important ones are the dependencies.

You can define dependencies to Rex modules and to Perl modules.

    Name: Frontend Service
    Description: The frontend service
    Author: jan gehring 
    License: Apache 2.0
    Require:
      Rex::NTP::Base:
        git: https://github.com/krimdomu/rex-ntp-base.git
        branch: master
      Rex::OS::Base:
        git: https://github.com/krimdomu/rex-os-base.git
        branch: master
    PerlRequire:
      - Moo

In this file you see that we define some dependencies to custom Rex modules located in git repositories. The `rexify --resolve-deps` command will read the **meta.yml** file and download all these dependencies into the **lib** directory.

With this in mind it is easy to have multiple environments with the same service pointing to different development branches.

### Rexfile - The code

Every service has its own Rexfile.

#### Load all required modules

    use Rex -feature => ['1.0'];
    use Rex::CMDB;
    use Rex::Test;
    use Rex::Group::Lookup::INI;

These lines loads all required modules.

-   Line 1: Load the basic Rex functions and enable all features from version 1.0 and above.
-   Line 2: Load the CMDB functions.
-   Line 3: Load the Rex::Test suite. With this you can test your Rex code with local virtual box virtual machines.
-   Line 4: Load the function to read Rex groups from ini files.

#### Load the server groups

    groups_file "server.ini";

Load all server groups from the file **server.ini**.

#### Configure the CMDB

    set cmdb => {
      type => "YAML",
      path => [
        "cmdb/{operatingsystem}/{hostname}.yml",
        "cmdb/{operatingsystem}/default.yml",
        "cmdb/{environment}/{hostname}.yml",
        "cmdb/{environment}/default.yml",
        "cmdb/{hostname}.yml",
        "cmdb/default.yml",
      ],
    };

Configure the CMDB. Here we define a custom search path. This will tell the CMDB to lookup the keys in the following order:

-   cmdb/{operatingsystem}/{hostname}.yml
-   cmdb/{operatingsystem}/default.yml
-   cmdb/{environment}/{hostname}.yml
-   cmdb/{environment}/default.yml
-   cmdb/{hostname}.yml
-   cmdb/default.yml

It is possible to use every Rex::Hardware variable inside the path.

-   environment (the environment defined by cli parameter -E)
-   server (the server name used to connect to the server)
-   kernelversion
-   kernelrelease
-   hostname
-   operatingsystem
-   operatingsystemrelease
-   architecture
-   domain
-   eth0\_mac
-   eth0\_ip
-   manufacturer
-   eth0\_broadcast
-   eth0\_netmask
-   and some others, too.

#### Include all required Rex modules

    include qw/
      Rex::OS::Base
      Rex::NTP::Base
      /;

Include all needed Rex modules. With **include** all the tasks inside these modules won't get displayed with `rex -T`.

#### The main task

    task "setup",

The main task. If you don't define the servers (or groups) in the task definition you can use the cli paramter -G or -H.

    task "setup", group => "frontend",

It is also possible to define the server or group to connect to.

    make {
      # run setup() task of Rex::OS::Base module
      Rex::OS::Base::setup();

      # run setup() task of Rex::NTP::Base module
      Rex::NTP::Base::setup();
    };

Inside the task we just call the tasks from the modules we have included above. All tasks can be called as a normal perl function, as long as the taskname doesn't conflict with other perl functions.

#### The last line

    # the last line of a Rexfile
    1;

The last line of a Rexfile is normaly a true value. This is not always needed, but it is safer to include it.

### Test before ship

Since version 0.46 Rex comes with a integration test suite. It is based on Rex::Box and currently supports VirtualBox. With it you can spawn local Virtual Box VMs and test your tasks on it.

The tests are stored in the t directory.

#### Example t/base.t test file

    use Rex::Test::Base;
    use Rex -feature => ['1.0'];

Load the **Rex::Test::Base** framework and the Rex basic commands.

    test {
      my $t = shift;
      $t->name("ubuntu test");

Create a new test named **ubuntu test**. For every test Rex will create a new vm.

      $t->base_vm("http://box.rexify.org/box/ubuntu-server-12.10-amd64.ova");
      $t->vm_auth(user => "root", password => "box");

Define the url where to download the base VM image and the authentication.

      $t->run_task("setup");

Define which task to run on the VM.

      $t->has_package("vim");
      $t->has_package("ntp");
      $t->has_package("unzip");

      $t->has_file("/etc/ntp.conf");

      $t->has_service_running("ntp");

      $t->has_content("/etc/passwd", qr{root:x:0:}ms);

      run "ls -l";
      $t->ok($? == 0, "ls -l returns success.");

Run the tests. You can also use normal rex functions here.

At the end finish the tests with:

      $t->finish;
    };
    1;

You can now run the tests with `rex Test:run`.

### Getting the code

Now, when you all have commit to your git repository you can use the rexify command to download them to (for example) a central deployment server.

    rexify --init=https://github.com/krimdomu/service-frontend.git

This will download everything into the folder **service-frontend**. The command also takes care of all dependencies and download them also into the **lib** folder.
