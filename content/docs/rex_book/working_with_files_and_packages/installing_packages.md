---
title: Installing Packages
date: 2019-12-01
---

Installing packages is easy. You can use the pkg function for this.

    ```perl
    use Rex -feature => ['1.0'];
    
    user "root";
    password "f00b4r";
    
    task "prepare_system",
      group => "frontends",
      sub {
        pkg "apache2", ensure => "present";
      };
    ```

If you have to install multiple packages you can use an array so that you don't have to write that much.

    ```perl
    use Rex -feature => ['1.0'];
    
    user "root";
    password "f00b4r";
    
    task "prepare_system",
      group => "frontends",
      sub {
        pkg [ "apache2", "libphp5-apache2", "mysql-server" ], ensure => "present";
      };
    ```

If you need to write a distribution independent module you can also use the case statement.

    ```perl
    user Rex -base;
    
    user "root";
    password "f00b4r";
    
    task "prepare_system",
      group => "frontends",
      sub {
        my $packages = case operating_system,
          Debian => [ "apache2", "libphp5-apache2" ],
          CentOS => [ "httpd",   "php5" ],
    
          pkg $packages, ensure => "present";
      };
    ```
