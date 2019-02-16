---
title: Pkg.pm
---

-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [SYNOPSIS](#SYNOPSIS)
-   [EXPORTED FUNCTIONS](#EXPORTED-FUNCTIONS)
    -   [pkg($package, %options)](#pkg-package-options-)
    -   [install($type, $data, $options)](#install-type-data-options-)
    -   [remove($type, $package, $options)](#remove-type-package-options-)
    -   [update\_system](#update_system)
    -   [installed\_packages](#installed_packages)
    -   [is\_installed](#is_installed)
    -   [update\_package\_db](#update_package_db)
    -   [repository($action, %data)](#repository-action-data-)
    -   [package\_provider\_for $os =&gt; $type;](#package_provider_for-os-type-)

# NAME

Rex::Commands::Pkg - Install/Remove Software packages

# DESCRIPTION

With this module you can install packages and files.

# SYNOPSIS

     install file => "/etc/passwd", {
                  source => "/export/files/etc/passwd"
                };

     install package => "perl";

# EXPORTED FUNCTIONS

## pkg($package, %options)

Since: 0.45

Use this resource to install or update a package. This resource will generate reports.

     pkg "httpd",
       ensure    => "latest",    # ensure that the newest version is installed (auto-update)
       on_change => sub { say "package was installed/updated"; };

     pkg "httpd",
       ensure => "absent";    # remove the package

     pkg "httpd",
       ensure => "present";   # ensure that some version is installed (no auto-update)

     pkg "httpd",
       ensure => "2.4.6";    # ensure that version 2.4.6 is installed

     pkg "apache-server",    # with a custom resource name
       package => "httpd",
       ensure  => "present";

## install($type, $data, $options)

The install function can install packages (for CentOS, OpenSuSE and Debian) and files.

If you need reports, please use the pkg() resource.

installing a package (This is only supported on CentOS, OpenSuSE and Debian systems.)  
     task "prepare", "server01", sub {
       install package => "perl";

       # or if you have to install more packages.
       install package => [
                      "perl",
                      "ntp",
                      "dbus",
                      "hal",
                      "sudo",
                      "vim",
                    ];
     };

installing a file  
This is deprecated since 0.9. Please use <span>File</span> *file* instead.

     task "prepare", "server01", sub {
       install file => "/etc/passwd", {
                    source => "/export/files/etc/passwd",
                    owner  => "root",
                    group  => "root",
                    mode  => 644,
                  };
     };

installing a file and do something if the file was changed.  
     task "prepare", "server01", sub {
       install file => "/etc/httpd/apache2.conf", {
                    source   => "/export/files/etc/httpd/apache2.conf",
                    owner    => "root",
                    group    => "root",
                    mode    => 644,
                    on_change => sub { say "File was modified!"; }
                  };
     };

installing a file from a template.  
     task "prepare", "server01", sub {
       install file => "/etc/httpd/apache2.tpl", {
                    source   => "/export/files/etc/httpd/apache2.conf",
                    owner    => "root",
                    group    => "root",
                    mode    => 644,
                    on_change => sub { say "File was modified!"; },
                    template  => {
                               greeting => "hello",
                               name    => "Ben",
                             },
                  };
     };

This function supports the following hooks:

before  
This gets executed before everything is done. The return value of this hook overwrite the original parameters of the function-call.

before\_change  
This gets executed right before the new package is installed. This hook is only available for package installations. If you need file hooks, you have to use the file() function.

after\_change  
This gets executed right after the new package was installed. This hook is only available for package installations. If you need file hooks, you have to use the file() function.

after  
This gets executed right before the install() function returns.

## remove($type, $package, $options)

This function will remove the given package from a system.

     task "cleanup", "server01", sub {
       remove package => "vim";
     };

## update\_system

This function does a complete system update.

For example *apt-get upgrade* or *yum update*.

     task "update-system", "server1", sub {
       update_system;
     };

If you want to get the packages that where updated, you can use the *on\_change* hook.

     task "update-system", "server1", sub {
       update_system
         on_change => sub {
           my (@modified_packages) = @_;
           for my $pkg (@modified_packages) {
             say "Name: $pkg->{name}";
             say "Version: $pkg->{version}";
             say "Action: $pkg->{action}";   # some of updated, installed or removed
           }
         };
     };

## installed\_packages

This function returns all installed packages and their version.

     task "get-installed", "server1", sub {

        for my $pkg (installed_packages()) {
          say "name    : " . $pkg->{"name"};
          say "  version: " . $pkg->{"version"};
        }

     };

## is\_installed

This function tests if $package is installed. Returns 1 if true. 0 if false.

     task "isinstalled", "server01", sub {
       if( is_installed("rex") ) {
         say "Rex is installed";
       }
       else {
         say "Rex is not installed";
       }
     };

## update\_package\_db

This function updates the local package database. For example, on CentOS it will execute *yum makecache*.

     task "update-pkg-db", "server1", "server2", sub {
       update_package_db;
       install package => "apache2";
     };

## repository($action, %data)

Add or remove a repository from the package manager.

For Debian: If you have no source repository, or if you don't want to add it, just remove the *source* parameter.

     task "add-repo", "server1", "server2", sub {
       repository "add" => "repository-name",
          url      => "http://rex.linux-files.org/debian/squeeze",
          key_url  => "http://rex.linux-files.org/DPKG-GPG-KEY-REXIFY-REPO"
          distro    => "squeeze",
          repository => "rex",
          source    => 1;
     };

To specify a key from a file use key\_file =&gt; '/tmp/mykeyfile'.

To use a keyserver use key\_server and key\_id.

For ALT Linux: If repository is unsigned, just remove the *sign\_key* parameter.

     task "add-repo", "server1", "server2", sub {
       repository "add" => "altlinux-sisyphus",
          url      => "ftp://ftp.altlinux.org/pub/distributions/ALTLinux/Sisyphus",
          sign_key  => "alt",
          arch     => "noarch, x86_64",
          repository => "classic";
     };

For CentOS, Mageia and SuSE only the name and the url are needed.

     task "add-repo", "server1", "server2", sub {
       repository add => "repository-name",
          url => 'http://rex.linux-files.org/CentOS/$releasever/rex/$basearch/';

     };

To remove a repository just delete it with its name.

     task "rm-repo", "server1", sub {
       repository remove => "repository-name";
     };

You can also use one call to repository to add repositories on multiple platforms:

     task "add-repo", "server1", "server2", sub {
      repository add => myrepo => {
        Ubuntu => {
          url => "http://foo.bar/repo",
          distro => "precise",
          repository => "foo",
        },
        Debian => {
          url => "http://foo.bar/repo",
          distro => "squeeze",
          repository => "foo",
        },
        CentOS => {
          url => "http://foo.bar/repo",
        },
      };
     };

## package\_provider\_for $os =&gt; $type;

To set another package provider as the default, use this function.

     user "root";

     group "db" => "db[01..10]";
     package_provider_for SunOS => "blastwave";

     task "prepare", group => "db", sub {
        install package => "vim";
     };

This example will install *vim* on every db server. If the server is a Solaris (SunOS) it will use the *blastwave* Repositories.
