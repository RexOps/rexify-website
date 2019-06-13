---
title: Authentication
---

Rex is capable to use two different SSH implementations under the hood: Net::SSH2 which is default on Windows, and the combination of Net::OpenSSH and Net::SFTP::Foreign on other platforms.

Those SSH implementations support many different authentication methods like passwords, key based or Kerberos authentication, or using and forwarding SSH agent. If you don't specify one of them explicitly, Rex will try to figure out which one to use, but that may or may not work for you, or be the one you expected. Rex also tries to use the current user's username for authentication if it's not specified with user.

All in all, despite the comfort the above behaviour might provide, we recommend to be explicit about the authentication method to be used as some servers may be configured to drop the connection after a couple of failed authentication attempts.

You can find examples on how to configure them below.

## Password authentication

The simplest way to authenticate against your servers is to use password authentication. For this you need a valid user and a password on the remote host.

    ```perl
    user 'root';
    password 'my_password';
    pass_auth;
    ```

Specifying `pass_auth` is optional.

## Key based authentication

Another simple way is to use a pair of private and public keys to authenticate against your servers.

If you don't have a pair of keys yet you can create them with ssh-keygen on Unix-like systems and with PuTTYgen on Windows.

Due to the differences of their implementations, the key here (pun intended) is that you have to include the path to both of your keys when using Net::SSH2, but you can omit them when using Net::OpenSSH.

### Net::SSH2

    ```perl
    user 'root';
    private_key '/path/to/your/private.key';
    public_key '/path/to/your/public.key';
    key_auth;
    ```

### Net::OpenSSH

    ```perl
    user 'root';
    key_auth;
    ```

If you use a passphrase with your private key, you can specify it simply as if it was a password:

### Net::SSH2

    ```perl
    user 'root';
    private_key '/path/to/your/private.key';
    public_key '/path/to/your/public.key';
    password 'my_password';
    key_auth;
    ```

### Net::OpenSSH

    ```perl
    user 'root';
    password 'my_password';
    key_auth;
    ```

## Using an SSH agent

If you can't or don't want to use any of the above methods, you can use agent authentication. Configuration for it is very similar to key based authentication, you only need to omit `key_auth`.

### Net::SSH2

    ```perl
    user 'root';
    private_key '/path/to/your/private.key';
    public_key '/path/to/your/public.key';
    ```

### Net::OpenSSH

    ```perl
    user 'root';
    ```

Important notes:

1.  For agent authentication to work, make sure the agent is running on your system.
2.  Agent forwarding only works with Net::OpenSSH.

## Kerberos authentication

As of version 0.42.0, Rex supports Kerberos authentication through Net::OpenSSH:

    ```perl
    user 'root';
    krb5_auth;
    ```
