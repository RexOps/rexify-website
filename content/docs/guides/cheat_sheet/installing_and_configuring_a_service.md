---
title: Installing and configuring a service
---

The most used functions in configuration management is installing/managing services and managing configuration files. In Rex you can do this with the file, pkg and service functions.

### file($remote\_file, %options)

Manage files on remote systems.

#### Options

-   ensure - Defines the state of the file. Valid parameters are present, absent, directory.
-   source - The local file that should be uploaded to the remote server.
-   content - Set the content directly. Can be used together with the template() function.
-   owner - The owner of the file.
-   group - The group the file should belong to.
-   mode - The file system privileges the file should have.
-   no\_overwrite - If set to TRUE the file won't be overwritten if the file already exists.
-   on\_change - A callback function that gets called when the file state changed. (For example if the file content was modified).

<!-- -->

    file "/etc/ntpd.conf",
      ensure => "present",
      source => "files/ntpd.conf",
      owner  => "root",
      group  => "root",
      mode   => 644,
      on_change => sub {
        service ntpd => "restart";
      };

### pkg($name, %options)

Install a package on the remote system.

#### Options

-   ensure - Defines the state of the package. Valid parameters are latest, present, absent or the version that should be enforced.
-   on\_change - A called function that gets called when the package state changed. (For example when it was updated)

<!-- -->

    pkg "ntpd",
      ensure => "latest",
      on_change => sub {
        service ntpd => "restart";
      };

### service

Manage the state of a service.

This function can be called as a resource or as a normal function to directly stop/start/restart/... services.

#### Options (for calling as a resource)

-   ensure - Defines the state of the service. Valid parameters are started, stopped.
-   start - Custom command to start the service.
-   stop - Custom command to stop the service.
-   status - Custom command to get the status of a service.
-   restart - Custom command to restart a service.
-   reload - Custom command to reload a service.

#### Example for calling as resource

    service "nptd",
      ensure => "started";

#### Example for calling as function

    service ntpd => "restart";

 
