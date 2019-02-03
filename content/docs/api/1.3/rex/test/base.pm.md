-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [EXAMPLE](#EXAMPLE)
-   [METHODS](#METHODS)
    -   [new(name =&gt; $test\_name)](#new-name-test_name-)
    -   [name($name)](#name-name-)
    -   [vm\_auth(%auth)](#vm_auth-auth-)
    -   [base\_vm($vm)](#base_vm-vm-)
    -   [redirect\_port($port)](#redirect_port-port-)
    -   [run\_task($task)](#run_task-task-)
-   [TEST METHODS](#TEST-METHODS)
    -   [has\_content($file, $regexp)](#has_content-file-regexp-)
    -   [has\_dir($path)](#has_dir-path-)
    -   [has\_file($file)](#has_file-file-)
    -   [has\_package($package, $version)](#has_package-package-version-)
    -   [has\_service\_running($service)](#has_service_running-service-)
    -   [has\_service\_stopped($service)](#has_service_stopped-service-)
    -   [has\_stat($file, $stat)](#has_stat-file-stat-)

# NAME

Rex::Test::Base - Basic Test Module

# DESCRIPTION

This is a basic test module to test your code with the help of local VMs. You can place your tests in the "t" directory.

# EXAMPLE

     use Rex::Test::Base;
     use Data::Dumper;
     use Rex -base;
     
     test {
       my $t = shift;
     
       $t->name("ubuntu test");
     
       $t->base_vm("http://box.rexify.org/box/ubuntu-server-12.10-amd64.ova");
       $t->vm_auth(user => "root", password => "box");
     
       $t->run_task("setup");
     
       $t->has_package("vim");
       $t->has_package("ntp");
       $t->has_package("unzip");
     
       $t->has_file("/etc/ntp.conf");
     
       $t->has_service_running("ntp");
     
       $t->has_content("/etc/passwd", qr{root:x:0:}ms);
     
       run "ls -l";
       $t->ok($? == 0, "ls -l returns success.");
     
       $t->finish;
     };
     
     1; # last line

# METHODS

## new(name =&gt; $test\_name)

Constructor if used in OO mode.

     my $test = Rex::Test::Base->new(name => "test_name");

## name($name)

The name of the test. A VM called $name will be created for each test. If the VM already exists, Rex will try to reuse it.

## vm\_auth(%auth)

Authentication options for the VM. It accepts the same parameters as `Rex::Box::Base->auth()`.

## base\_vm($vm)

The URL to a base image to be used for the test VM.

## redirect\_port($port)

Redirect local $port to the VM's SSH port (default: 2222).

## run\_task($task)

The task to run on the test VM. You can run multiple tasks by passing an array reference.

# TEST METHODS

## has\_content($file, $regexp)

Test if the content of $file matches against $regexp.

## has\_dir($path)

Test if $path is present and is a directory.

## has\_file($file)

Test if $file is present.

## has\_package($package, $version)

Test if $package is installed, optionally at $version.

## has\_service\_running($service)

Test if $service is running.

## has\_service\_stopped($service)

Test if $service is stopped.

## has\_stat($file, $stat)

Test if $file has properties described in hash reference $stat. List of supported checks:

group  

owner  
