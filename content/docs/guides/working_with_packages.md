---
title: Working with packages
---

If you want to install or remove packages on your server Rex gives you a few functions to do this. Rex tries to guess the right package provider based on the platform Rex connects to.
If you want to use a special package provider (for example, if you're using SunOS and want to use OpenCSW) you can define the package provider with `package_provider_for $os => $provider_name`.

## Installing a Package

To install a package you can use the `pkg` function.

    task "prepare", "server1", sub {
      pkg "apache2",
        ensure => "present";
    };

If you want to install multiple packages you can do it by providing an array reference.

    task "prepare", "server1", sub {
      pkg [ qw/apache2 vim php5/ ],
        ensure => "present";
    };

If you want to install a special version of a package you just need to specify the version option.

    task "prepare", "server1", sub {
      pkg "apache2",
        ensure => "2.2.4";
    };

## Removing a Package

If you don't need a package anymore you can remove it with the remove function.

    task "prepare", "server1", sub {
      pkg "apache2",
        ensure => "absent";
    };

## Adding a Package Repository

Sometimes you have to add custom repositories to your Server. This can be done with the repository function. In the following code block you'll see an example for Debian and CentOS.

### Debian

    task "prepare", "server2", sub {
       # add a repository for debian/ubuntu
       repository add => "myrepo",
          url => "http://foo.bar/repo",
          distro => "squeeze",
          repository => "stable";
    };

### CentOS

    task "prepare", "server2", sub {
       # add a repository for redhat/centos
       repository add => "myrepo",
          url => "http://foo.bar/repo";
    };

After you've added a new repository you need to run update\_package\_db to update the package database so that you can install packages from these repositories.

    task "prepare", "server2", sub {
       # add a repository for redhat/centos
       repository add => "myrepo",
          url => "http://foo.bar/repo";
           
       # update package database
       update_package_db;
    };

## Supported Package Providers

Rex supports the following package providers:

-   For ALT Linux: rpm
-   For Debian Linux: apt
-   For FreeBSD: pkg
-   For Gentoo: emerge
-   For Mageia: urpmi
-   For NetBSD: pkg
-   For OpenBSD: pkg
-   For OpenWrt: opkg
-   For Redhat/CentOS/ScientificLinux: yum
-   For SunOS: pkgadd, pkg, OpenCSW, Blastwave
-   For SuSE: zypper
-   For Ubuntu: apt

