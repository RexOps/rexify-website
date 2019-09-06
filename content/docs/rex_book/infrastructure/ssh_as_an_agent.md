---
title: SSH as an agent
---

To setup an environment to work with Rex you don't have to do much. You have to install Rex on your workstation or a central administration server. For most distributions you'll find packages on the package server. If you want to build Rex from source you have to install the following dependencies.

Perl (at least version 5.8.8)

-   libssh2
-   openssl
-   rsync
-   Net::OpenSSH
-   Net::SFTP::Foreign
-   JSON::XS
-   XML::Simple
-   LWP::UserAgent
-   Digest::HMAC
-   Expect
-   DBI
-   YAML

On the server side you only need a working perl installation. The version doesn't matter. And of course a working ssh server and a valid user.

Rex will connect to your servers via SSH and execute the commands you've defined in the tasks. The logic is all done by your workstation (or administration server). This means, if you query a database, dns or a CMDB inside a task your workstation will do this and not your server. This is essential for security.

## Parallelism

If you have many servers you want to connect to, you ususally don't want to connect sequentially. You can define the number of parallel connections Rex should use.

    ```perl
    use Rex -feature => ['1.0'];
    
    user "root";
    password "foob4r";
    
    group frontends => "frontend[01..50]";
    
    parallelism 15;
    
    task "prepare",
      group => "frontends",
      sub {
      # do something
      };
    ```

This will connect to 15 servers in parallel and executes the task.
