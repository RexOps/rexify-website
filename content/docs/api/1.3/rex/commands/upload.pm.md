---
title: Upload.pm
---

-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [SYNOPSIS](#SYNOPSIS)
-   [EXPORTED FUNCTIONS](#EXPORTED-FUNCTIONS)
    -   [upload($local, $remote)](#upload-local-remote-)

# NAME

Rex::Commands::Upload - Upload a local file to a remote server

# DESCRIPTION

With this module you can upload a local file via sftp to a remote host.

# SYNOPSIS

     task "upload", "remoteserver", sub {
       upload "localfile", "/remote/file";
     };

# EXPORTED FUNCTIONS

## upload($local, $remote)

Perform an upload. If $remote is a directory the file will be uploaded to that directory.

     task "upload", "remoteserver", sub {
       upload "localfile", "/path";
     };

This function supports the following hooks:

before  
This gets executed before everything is done. The return value of this hook overwrite the original parameters of the function-call.

before\_change  
This gets executed right before the new file is written.

after\_change  
This gets executed right after the file was written.

after  
This gets executed right before the upload() function returns.
