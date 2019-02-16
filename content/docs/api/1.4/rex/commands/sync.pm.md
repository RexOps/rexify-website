---
title: Sync.pm
---

-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [SYNOPSIS](#SYNOPSIS)

# NAME

Rex::Commands::Sync - Sync directories

# DESCRIPTION

This module can sync directories between your Rex system and your servers without the need of rsync.

# SYNOPSIS

     use Rex::Commands::Sync;

     task "prepare", "mysystem01", sub {
       # upload directory recursively to remote system.
       sync_up "/local/directory", "/remote/directory";

       sync_up "/local/directory", "/remote/directory", {
         # setting custom file permissions for every file
         files => {
           owner => "foo",
           group => "bar",
           mode  => 600,
         },
         # setting custom directory permissions for every directory
         directories => {
           owner => "foo",
           group => "bar",
           mode  => 700,
         },
         exclude => [ '*.tmp' ],
         parse_templates => TRUE|FALSE,
         on_change => sub {
          my (@files_changed) = @_;
         },
       };

       # download a directory recursively from the remote system to the local machine
       sync_down "/remote/directory", "/local/directory";
     };
