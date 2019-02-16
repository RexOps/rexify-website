---
title: Fs.pm
---

-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [SYNOPSIS](#SYNOPSIS)
-   [EXPORTED FUNCTIONS](#EXPORTED-FUNCTIONS)
    -   [list\_files("/path");](#list_files-path-)
    -   [ls($path)](#ls-path-)
    -   [symlink($from, $to)](#symlink-from-to-)
    -   [ln($from, $to)](#ln-from-to-)
    -   [unlink($file)](#unlink-file-)
    -   [rm($file)](#rm-file-)
    -   [rmdir($dir)](#rmdir-dir-)
    -   [mkdir($newdir)](#mkdir-newdir-)
    -   [chown($owner, $file)](#chown-owner-file-)
    -   [chgrp($group, $file)](#chgrp-group-file-)
    -   [chmod($mode, $file)](#chmod-mode-file-)
    -   [stat($file)](#stat-file-)
    -   [is\_file($file)](#is_file-file-)
    -   [is\_dir($dir)](#is_dir-dir-)
    -   [is\_symlink($file)](#is_symlink-file-)
    -   [is\_readable($file)](#is_readable-file-)
    -   [is\_writable($file)](#is_writable-file-)
    -   [is\_writeable($file)](#is_writeable-file-)
    -   [readlink($link)](#readlink-link-)
    -   [rename($old, $new)](#rename-old-new-)
    -   [mv($old, $new)](#mv-old-new-)
    -   [chdir($newdir)](#chdir-newdir-)
    -   [cd($newdir)](#cd-newdir-)
    -   [df(\[$device\])](#df-device-)
    -   [du($path)](#du-path-)
    -   [cp($source, $destination)](#cp-source-destination-)
    -   [mount($device, $mount\_point, @options)](#mount-device-mount_point-options-)
    -   [umount($mount\_point)](#umount-mount_point-)
    -   [glob($glob)](#glob-glob-)

# NAME

Rex::Commands::Fs - Filesystem commands

# DESCRIPTION

With this module you can do file system tasks like creating a directory, deleting files, moving files, and more.

# SYNOPSIS

     my @files = list_files "/etc";
     
     unlink("/tmp/file");
     
     rmdir("/tmp");
     mkdir("/tmp");
     
     my %stat = stat("/etc/passwd");
     
     my $link = readlink("/path/to/a/link");
     symlink("/source", "/dest");
     
     rename("oldname", "newname");
     
     chdir("/tmp");
     
     is_file("/etc/passwd");
     is_dir("/etc");
     is_writeable("/tmp");
     is_writable("/tmp");
     
     chmod 755, "/tmp";
     chown "user", "/tmp";
     chgrp "group", "/tmp";

# EXPORTED FUNCTIONS

## list\_files("/path");

This function list all entries (files, directories, ...) in a given directory and returns a array.

     task "ls-etc", "server01", sub {
       my @tmp_files = grep { /\.tmp$/ } list_files("/etc");
     };

This command will not be reported.

## ls($path)

Just an alias for *list\_files*

## symlink($from, $to)

This function will create a symlink from $from to $to.

     task "symlink", "server01", sub {
       symlink("/var/www/versions/1.0.0", "/var/www/html");
     };

## ln($from, $to)

ln is an alias for *symlink*

## unlink($file)

This function will remove the given file.

     task "unlink", "server01", sub {
       unlink("/tmp/testfile");
     };

## rm($file)

This is an alias for unlink.

## rmdir($dir)

This function will remove the given directory.

     task "rmdir", "server01", sub {
       rmdir("/tmp");
     };

Since: 0.45 Please use the file() resource instead.

     task "prepare", sub {
       file "/tmp",
         ensure => "absent";
     };

## mkdir($newdir)

This function will create a new directory.

Since: 0.45 Please use the file() resource instead.

     task "prepare", sub {
       file "/tmp",
         ensure => "directory",
         owner  => "root",
         group  => "root",
         mode   => 1777;
     };
     
     task "mkdir", "server01", sub {
       mkdir "/tmp";
     
       mkdir "/tmp",
         owner => "root",
         group => "root",
         mode => 1777;
     };

## chown($owner, $file)

Change the owner of a file or a directory.

     chown "www-data", "/var/www/html";
     
     chown "www-data", "/var/www/html",
                    recursive => 1;

This command will not be reported.

If you want to use reports, please use the file() resource instead.

## chgrp($group, $file)

Change the group of a file or a directory.

     chgrp "nogroup", "/var/www/html";
     
     chgrp "nogroup", "/var/www/html",
                  recursive => 1;

This command will not be reported.

If you want to use reports, please use the file() resource instead.

## chmod($mode, $file)

Change the permissions of a file or a directory.

     chmod 755, "/var/www/html";
     
     chmod 755, "/var/www/html",
              recursive => 1;

This command will not be reported.

If you want to use reports, please use the file() resource instead.

## stat($file)

This function will return a hash with the following information about a file or directory.

mode  

size  

uid  

gid  

atime  

mtime  

<!-- -->

     task "stat", "server01", sub {
       my %file_stat = stat("/etc/passwd");
     };

This command will not be reported.

## is\_file($file)

This function tests if $file is a file. Returns 1 if true. 0 if false.

     task "isfile", "server01", sub {
       if( is_file("/etc/passwd") ) {
         say "it is a file.";
       }
       else {
         say "hm, this is not a file.";
       }
     };

This command will not be reported.

## is\_dir($dir)

This function tests if $dir is a directory. Returns 1 if true. 0 if false.

     task "isdir", "server01", sub {
       if( is_dir("/etc") ) {
         say "it is a directory.";
       }
       else {
         say "hm, this is not a directory.";
       }
     };

This command will not be reported.

## is\_symlink($file)

This function tests if $file is a symlink. Returns 1 if true. 0 if false.

     task "issym", "server01", sub {
       if( is_symlink("/etc/foo.txt") ) {
         say "it is a symlink.";
       }
       else {
         say "hm, this is not a symlink.";
       }
     };

This command will not be reported.

## is\_readable($file)

This function tests if $file is readable. It returns 1 if true. 0 if false.

     task "readable", "server01", sub {
       if( is_readable("/etc/passwd") ) {
         say "passwd is readable";
       }
       else {
         say "not readable.";
       }
     };

This command will not be reported.

## is\_writable($file)

This function tests if $file is writable. It returns 1 if true. 0 if false.

     task "writable", "server01", sub {
       if( is_writable("/etc/passwd") ) {
         say "passwd is writable";
       }
       else {
         say "not writable.";
       }
     };

This command will not be reported.

## is\_writeable($file)

This is only an alias for *is\_writable*.

This command will not be reported.

## readlink($link)

This function returns the link endpoint if $link is a symlink. If $link is not a symlink it will die.

     task "islink", "server01", sub {
       my $link;
       eval {
         $link = readlink("/tmp/testlink");
       };
     
       say "this is a link" if($link);
     };

This command will not be reported.

## rename($old, $new)

This function will rename $old to $new. Will return 1 on success and 0 on failure.

     task "rename", "server01", sub {
       rename("/tmp/old", "/tmp/new");
     };

## mv($old, $new)

mv is an alias for *rename*.

## chdir($newdir)

This function will change the current workdirectory to $newdir. This function currently only works local.

     task "chdir", "server01", sub {
       chdir("/tmp");
     };

This command will not be reported.

## cd($newdir)

This is an alias of *chdir*.

## df(\[$device\])

This function returns a hashRef reflecting the output of *df*

     task "df", "server01", sub {
        my $df = df();
        my $df_on_sda1 = df("/dev/sda1");
     };

This command will not be reported.

## du($path)

Returns the disk usage of $path.

     task "du", "server01", sub {
       say "size of /var/www: " . du("/var/www");
     };

This command will not be reported.

## cp($source, $destination)

cp will copy $source to $destination (it is recursive)

     task "cp", "server01", sub {
        cp("/var/www", "/var/www.old");
     };

## mount($device, $mount\_point, @options)

Mount devices.

     task "mount", "server01", sub {
       mount "/dev/sda5", "/tmp";
       mount "/dev/sda6", "/mnt/sda6",
              ensure    => "present",
              type      => "ext3",
              options   => [qw/noatime async/],
              on_change => sub { say "device mounted"; };
       #
       # mount persistent with entry in /etc/fstab
     
       mount "/dev/sda6", "/mnt/sda6",
              ensure     => "persistent",
              type       => "ext3",
              options    => [qw/noatime async/],
              on_change  => sub { say "device mounted"; };
     
       # to umount a device
       mount "/dev/sda6", "/mnt/sda6",
              ensure => "absent";
     
     };

In order to be more aligned with \`mount\` terminology, the previously used \`fs\` option has been deprecated in favor of the \`type\` option. The \`fs\` option is still supported and works as previously, but Rex prints a warning if it is being used. There's also a warning if both \`fs\` and \`type\` options are specified, and in this case \`type\` will be used.

## umount($mount\_point)

Unmount device.

     task "umount", "server01", sub {
       umount "/tmp";
     };

## glob($glob)

     task "glob", "server1", sub {
       my @files_with_p = grep { is_file($_) } glob("/etc/p*");
     };

This command will not be reported.
