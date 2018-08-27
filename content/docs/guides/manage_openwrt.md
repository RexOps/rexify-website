[OpenWrt](https://openwrt.org/) is a Linux distribution for embedded devices and it is primarily aimed for and used on routers. This means that every component is optimized for size to fit into the limited resource constraints of these devices. As a result some things are working a bit differently than on a full-blown desktop or server distribution. This guide tries to help you getting started with using Rex to manage OpenWrt boxes.

Overview
--------

### What's working?

Please see the official compatibility page. You may also want to check the current project weather on build.rexify.org.

### Known limitations

-   Service status
    Despite OpenWrt provides a service\_check() function in /lib/functions/service.sh, it seems that it's only sporadically used in initscripts. Nevertheless Rex currently implements its service status check via this function but it's more of a workaround than a solution. It's also worth noting that sometimes the initscript's name and its executable's name are not the same (e.g cron vs. crond). You should use the executable's name in your OpenWrt status checks.
-   Missing renice
    AFAIK renice isn't available for OpenWrt.
-   Inventory gathering
    OpenWrt doesn't provide dmidecode for all architectures so this might or might not work for you.

### Requirements

-   &gt;=rex-0.43: initial support has been added in this release
-   enabled no\_tty feature flag when using OpenSSH connection mode
-   Attitude Adjustment (12.09 final) or Barrier Breaker (14.07 final)

Generally you'll need the following packages on your OpenWrt box on top of a vanilla install:

-   SFTP server: openssh-sftp-server or gesftpserver (only available for 12.09)
-   perl
-   perl modules: perlbase-bytes perlbase-data perlbase-digest perlbase-essential perlbase-file perlbase-xsloader
-   if you use &gt;=rex-0.46: coreutils-nohup (required for service handling)

Optional packages (only for specific Rex functions):

-   sync\_up: rsync
-   user management: shadow-groupadd shadow-groupdel shadow-groupmod shadow-useradd shadow-userdel shadow-usermod
-   inventory gathering: dmidecode
-   swap handling: swap-utils (+ block-mount on 14.07)

#### Details

##### SFTP server

By default OpenWrt doesn't provide an SFTP server. As Rex does lots of lower level operations via SFTP (`is_dir()`, `is_file()`, ...), the first package you should install on your box is either openssh-sftp-server or gesftpserver.

A massively subjective comparison of these two may help to make your decision:

##### openssh-sftp-server

-       easier to set up
-       a bit smaller size in itself
-       depends on libopenssl and zlib (and they are "huge" and probably not needed by other packages)
-       only supports SFTP v3 (that should be fine in general though)
-       widespread use
-       BSD licensed

It can be set up with the following commands:

    opkg update
    opkg install openssh-sftp-server

##### gesftpserver

-   only available for 12.09
-   needs some (minimal) tinkering after installation
-   a bit bigger in size in itself
-   no cumbersome dependencies, good for minimal systems
-   supports SFTP v3-v6
-   still under development
-   GPL licensed

It can be set up with the following commands:

    opkg update
    opkg install gesftpserver
    mkdir /usr/libexec
    ln -s /usr/bin/gesftpserver /usr/libexec/sftp-server

If you want to automate the set up of the chosen SFTP server on a fresh OpenWrt installation, just put the according steps into `run` calls in a Rex task. The bottom line is to don't try to use the built-in `mkdir` and `symlink` functions at this point as they are broken before you have an SFTP server in place.
You can find out more about gesftpserver and a comparison of different SFTP implementations/versions on their [website](http://www.greenend.org.uk/rjk/sftpserver/).

##### Perl

You'll need to install the following packages:

-   perl: obviously
-   perlbase-bytes, perlbase-essential: very basic set of perl modules
-   perlbase-data: for Data::Dumper
-   perlbase-file: for glob operations
-   perlbase-digest: perlbase-data dependency and it is nice to have in order to speed up file operations in general (via MD5 hashing)
-   perlbase-xsloader: perlbase-data and perlbase-file dependency

##### rsync

Merely needed by sync\_up functionality.

##### shadow-\*

OpenWrt doesn't provide traditional user and group management commands by default as these procedures are rarely needed in the majority of the targeted use cases. However, if you really need to do these type of stuff on your router, you're in luck, as you can easily install these packages from the official repository:

-   shadow-groupadd
-   shadow-groupdel
-   shadow-groupmod
-   shadow-useradd
-   shadow-userdel
-   shadow-usermod

