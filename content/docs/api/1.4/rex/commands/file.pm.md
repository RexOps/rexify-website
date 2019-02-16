---
title: File.pm
---

-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [SYNOPSIS](#SYNOPSIS)
-   [EXPORTED FUNCTIONS](#EXPORTED-FUNCTIONS)
    -   [template($file, @params)](#template-file-params-)
    -   [file($file\_name, %options)](#file-file_name-options-)
    -   [file\_write($file\_name)](#file_write-file_name-)
    -   [file\_append($file\_name)](#file_append-file_name-)
    -   [file\_read($file\_name)](#file_read-file_name-)
    -   [cat($file\_name)](#cat-file_name-)
    -   [delete\_lines\_matching($file, $regexp)](#delete_lines_matching-file-regexp-)
    -   [delete\_lines\_according\_to($search, $file, @options)](#delete_lines_according_to-search-file-options-)
    -   [append\_if\_no\_such\_line($file, $new\_line, @regexp)](#append_if_no_such_line-file-new_line-regexp-)
    -   [append\_or\_amend\_line($file, $line, @regexp)](#append_or_amend_line-file-line-regexp-)
    -   [extract($file \[, %options\])](#extract-file-options-)
    -   [sed($search, $replace, $file)](#sed-search-replace-file-)

# NAME

Rex::Commands::File - Transparent File Manipulation

# DESCRIPTION

With this module you can manipulate files.

# SYNOPSIS

     task "read-passwd", "server01", sub {
       my $fh = file_read "/etc/passwd";
       for my $line = ($fh->read_all) {
         print $line;
       }
       $fh->close;
     };
     
     task "read-passwd2", "server01", sub {
       say cat "/etc/passwd";
     };


     task "write-passwd", "server01", sub {
       my $fh = file_write "/etc/passwd";
       $fh->write("root:*:0:0:root user:/root:/bin/sh\n");
       $fh->close;
     };
     
     delete_lines_matching "/var/log/auth.log", matching => "root";
     delete_lines_matching "/var/log/auth.log", matching => qr{Failed};
     delete_lines_matching "/var/log/auth.log",
                    matching => "root", qr{Failed}, "nobody";
     
     file "/path/on/the/remote/machine",
       source => "/path/on/local/machine";
     
     file "/path/on/the/remote/machine",
       content => "foo bar";
     
     file "/path/on/the/remote/machine",
       source => "/path/on/local/machine",
       owner  => "root",
       group  => "root",
       mode  => 400,
       on_change => sub { say "File was changed."; };

# EXPORTED FUNCTIONS

## template($file, @params)

Parse a template and return the content.

     my $content = template("/files/templates/vhosts.tpl",
                  name => "test.lan",
                  webmaster => 'webmaster@test.lan');

The file name specified is subject to "path\_map" processing as documented under the file() function to resolve to a physical file name.

In addition to the "path\_map" processing, if the **-E** command line switch is used to specify an environment name, existence of a file ending with '.&lt;env&gt;' is checked and has precedence over the file without one, if it exists. E.g. if rex is started as:

     $ rex -E prod task1

then in task1 defined as:

     task "task1", sub {

        say template("files/etc/ntpd.conf");

     };

will print the content of 'files/etc/ntpd.conf.prod' if it exists.

Note: the appended environment mechanism is always applied, after the 'path\_map' mechanism, if that is configured.

## file($file\_name, %options)

This function is the successor of *install file*. Please use this function to upload files to your server.

     task "prepare", "server1", "server2", sub {
       file "/file/on/remote/machine",
         source => "/file/on/local/machine";
     
       file "/etc/hosts",
         content => template("templates/etc/hosts.tpl"),
         owner  => "user",
         group  => "group",
         mode   => 700,
         on_change => sub { say "Something was changed." };
     
       file "/etc/motd",
         content => `fortune`;
     
       file "/etc/named.conf",
         content    => template("templates/etc/named.conf.tpl"),
         no_overwrite => TRUE;  # this file will not be overwritten if already exists.
     
       file "/etc/httpd/conf/httpd.conf",
         source => "/files/etc/httpd/conf/httpd.conf",
         on_change => sub { service httpd => "restart"; };
     
       file "/etc/named.d",
         ensure => "directory",  # this will create a directory
         owner  => "root",
         group  => "root";
     
       file "/etc/motd",
         ensure => "absent";   # this will remove the file or directory
     
     };

The first parameter is either a string or an array reference. In the latter case the function is called for all strings in the array. Therefore, the following constructs are equivalent:

      file '/tmp/test1', ensure => 'directory';
      file '/tmp/test2', ensure => 'directory';

      file [ qw( /tmp/test1 /tmp/test2 ) ], ensure => 'directory'; # use array ref

      file [ glob('/tmp/test{1,2}') ], ensure => 'directory'; # explicit glob call for array contents

Use the glob carefully as **it can leak local filesystem information** (e.g. when using wildcards).

The *source* is subject to a path resolution algorithm. This algorithm can be configured using the *set* function to set the value of the *path\_map* variable to a hash containing path prefixes as its keys. The associated values are arrays listing the prefix replacements in order of (decreasing) priority.

      set "path_map", {
        "files/" => [ "files/{environment}/{hostname}/_root_/",
                      "files/{environment}/_root_/" ]
      };

With this configuration, the file "files/etc/ntpd.conf" will be probed for in the following locations:

     - files/{environment}/{hostname}/_root_/etc/ntpd.conf
     - files/{environment}/_root_/etc/ntpd.conf
     - files/etc/ntpd.conf

Furthermore, if a path prefix matches multiple prefix entries in 'path\_map', e.g. "files/etc/ntpd.conf" matching both "files/" and "files/etc/", the longer matching prefix(es) have precedence over shorter ones. Note that keys without a trailing slash (i.e. "files/etc") will be treated as having a trailing slash when matching the prefix ("files/etc/").

If no file is found using the above procedure and *source* is relative, it will search from the location of your *Rexfile* or the *.pm* file if you use Perl packages.

All the possible variables ('{environment}', '{hostname}', ...) are documented in the CMDB YAML documentation.

This function supports the following hooks:

before  
This gets executed before everything is done. The return value of this hook overwrite the original parameters of the function-call.

before\_change  
This gets executed right before the new file is written. Only with *content* parameter. For the *source* parameter the hook of the upload function is used.

after\_change  
This gets executed right after the file was written. Only with *content* parameter. For the *source* parameter the hook of the upload function is used.

after  
This gets executed right before the file() function returns.

## file\_write($file\_name)

This function opens a file for writing (it will truncate the file if it already exists). It returns a Rex::FS::File object on success.

On failure it will die.

     my $fh;
     eval {
       $fh = file_write("/etc/groups");
     };
     
     # catch an error
     if($@) {
       print "An error occured. $@.\n";
     }
     
     # work with the filehandle
     $fh->write("...");
     $fh->close;

## file\_append($file\_name)

## file\_read($file\_name)

This function opens a file for reading. It returns a Rex::FS::File object on success.

On failure it will die.

     my $fh;
     eval {
       $fh = read("/etc/groups");
     };
     
     # catch an error
     if($@) {
       print "An error occured. $@.\n";
     }
     
     # work with the filehandle
     my $content = $fh->read_all;
     $fh->close;

## cat($file\_name)

This function returns the complete content of $file\_name as a string.

     print cat "/etc/passwd";

## delete\_lines\_matching($file, $regexp)

Delete lines that match $regexp in $file.

     task "clean-logs", sub {
        delete_lines_matching "/var/log/auth.log" => "root";
     };

## delete\_lines\_according\_to($search, $file, @options)

This is the successor of the delete\_lines\_matching() function. This function also allows the usage of an on\_change hook.

It will search for $search in $file and remove the found lines. If on\_change hook is present it will execute this if the file was changed.

     task "cleanup", "server1", sub {
       delete_lines_according_to qr{^foo:}, "/etc/passwd",
        on_change => sub {
          say "removed user foo.";
        };
     };

## append\_if\_no\_such\_line($file, $new\_line, @regexp)

Append $new\_line to $file if none in @regexp is found. If no regexp is supplied, the line is appended unless there is already an identical line in $file.

     task "add-group", sub {
       append_if_no_such_line "/etc/groups", "mygroup:*:100:myuser1,myuser2", on_change => sub { service sshd => "restart"; };
     };

Since 0.42 you can use named parameters as well

     task "add-group", sub {
       append_if_no_such_line "/etc/groups",
         line  => "mygroup:*:100:myuser1,myuser2",
         regexp => qr{^mygroup},
         on_change => sub {
                    say "file was changed, do something.";
                  };
     
       append_if_no_such_line "/etc/groups",
         line  => "mygroup:*:100:myuser1,myuser2",
         regexp => [qr{^mygroup:}, qr{^ourgroup:}]; # this is an OR
     };

## append\_or\_amend\_line($file, $line, @regexp)

Similar to <span>append\_if\_no\_such\_line</span>, but if the line in the regexp is found, it will be updated. Otherwise, it will be appended.

     task "update-group", sub {
       append_or_amend_line "/etc/groups",
         line  => "mygroup:*:100:myuser3,myuser4",
         regexp => qr{^mygroup},
         on_change => sub {
                    say "file was changed, do something.";
                  };
     };

## extract($file \[, %options\])

This function extracts a file. The target directory optionally specified with the \`to\` option will be created automatically.

Supported formats are .box, .tar, .tar.gz, .tgz, .tar.Z, .tar.bz2, .tbz2, .zip, .gz, .bz2, .war, .jar.

     task prepare => sub {
       extract "/tmp/myfile.tar.gz",
        owner => "root",
        group => "root",
        to   => "/etc";
     
       extract "/tmp/foo.tgz",
        type => "tgz",
        mode => "g+rwX";
     };

Can use the type=&gt; option if the file suffix has been changed. (types are tar, tgz, tbz, zip, gz, bz2)

## sed($search, $replace, $file)

Search some string in a file and replace it.

     task sar => sub {
       # this will work line by line
       sed qr{search}, "replace", "/var/log/auth.log";
     
       # to use it in a multiline way
       sed qr{search}, "replace", "/var/log/auth.log",
        multiline => TRUE;
     };
