-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [SYNOPSIS](#SYNOPSIS)
-   [EXPORTED FUNCTIONS](#EXPORTED-FUNCTIONS)
    -   [service($service, $action, \[$option\])](#service-service-action-option-)
    -   [service\_provider\_for $os =&gt; $type;](#service_provider_for-os-type-)

# NAME

Rex::Commands::Service - Manage System Services

# DESCRIPTION

With this module you can manage Linux services.

# SYNOPSIS

     use Rex::Commands::Service

     service apache2 => "start";

     service apache2 => "stop";

     service apache2 => "restart";

     service apache2 => "status";

     service apache2 => "reload";

     service apache2 => "ensure", "started";

     service apache2 => "ensure", "stopped";

# EXPORTED FUNCTIONS

## service($service, $action, \[$option\])

The service function accepts 2 parameters. The first is the service name and the second the action you want to perform.

starting a service  
     task "start-service", "server01", sub {
       service apache2 => "start";
     };

stopping a service  
     task "stop-service", "server01", sub {
       service apache2 => "stop";
     };

restarting a service  
     task "restart-service", "server01", sub {
       service apache2 => "restart";
     };

checking status of a service  
     task "status-service", "server01", sub {
       if( service apache2 => "status" ) {
         say "Apache2 is running";
       }
       else {
         say "Apache2 is not running";
       }
     };

reloading a service  
     task "reload-service", "server01", sub {
       service apache2 => "reload";
     };

ensure that a service will started at boot time  
     task "prepare", sub {
       service "apache2",
         ensure => "started";
     };

ensure that a service will NOT be started.  
     task "prepare", sub {
       service "apache2",
         ensure => "stopped";
     };

If you need to define a custom command for start, stop, restart, reload or status you can do this with the corresponding options.

     task "prepare", sub {
       service "apache2",
         ensure  => "started",
         start   => "/usr/local/bin/httpd -f /etc/my/httpd.conf",
         stop    => "killall httpd",
         status  => "ps -efww | grep httpd",
         restart => "killall httpd && /usr/local/bin/httpd -f /etc/my/httpd.conf",
         reload  => "killall httpd && /usr/local/bin/httpd -f /etc/my/httpd.conf";
     };

This function supports the following hooks:

before\_*action*  
For example: before\_start, before\_stop, before\_restart

This gets executed right before the service action.

after\_*action*  
For example: after\_start, after\_stop, after\_restart

This gets executed right after the service action.

## service\_provider\_for $os =&gt; $type;

To set another service provider as the default, use this function.

     user "root";

     group "db" => "db[01..10]";
     service_provider_for SunOS => "svcadm";

     task "start", group => "db", sub {
        service ssh => "restart";
     };

This example will restart the *ssh* service via svcadm (but only on SunOS, on other operating systems it will use the default).
