---
title: PkgConf.pm
---

-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [SYNOPSIS](#SYNOPSIS)
-   [EXPORTED FUNCTIONS](#EXPORTED-FUNCTIONS)
    -   [get\_pkgconf($package, \[$question\])](#get_pkgconf-package-question-)
    -   [set\_pkgconf($package, $values, \[%options\])](#set_pkgconf-package-values-options-)

# NAME

Rex::Commands::PkgConf - Configure packages

# DESCRIPTION

With this module you can configure packages. Currently it only supports Debian (using debconf), but it is designed to be extendable.

# SYNOPSIS

     my %options = get_pkgconf('postfix');
     say $options{'postfix/relayhost'}->{value};

     # Only obtain one value
     my %options = get_pkgconf('postfix', 'postfix/relayhost');
     say $options{'postfix/relayhost'}->{value};

     # Set options
     set_pkgconf("postfix", [
        {question => 'chattr', type => 'boolean', value => 'false'},
        {question => 'relayhost', type => 'string', value => 'relay.example.com'},
     ]);

     # Don't update if it's already set
     set_pkgconf("mysql-server-5.5", [
        {question => 'mysql-server/root_password', type => 'string', value => 'mysecret'},
        {question => 'mysql-server/root_password_again', type => 'string', value => 'mysecret'},
     ], no_update => 1);

# EXPORTED FUNCTIONS

## get\_pkgconf($package, \[$question\])

Use this to query existing package configurations.

Without a question specified, it will return all options for the specified package as a hash.

With a question specified, it will return only that option

Each question is returned with the question as the key, and the value as a hashref. The hashref contains the keys: question, value and already\_set. already\_set is true if the question has already been answered.

     # Only obtain one value
     my %options = get_pkgconf('postfix', 'postfix/relayhost');
     say $options{'postfix/relayhost'}->{question};
     say $options{'postfix/relayhost'}->{value};
     say $options{'postfix/relayhost'}->{already_set};

## set\_pkgconf($package, $values, \[%options\])

Use this to set package configurations.

At least the package name and values must be specified. Values must be an array ref, with each item containing a hashref with the attributes specified that are required by the package configuration program.

For example, for debconf, this must be the question, the type and answer. In this case, the types can be any accetable debconf type: string, boolean, select, multiselect, note, text, password.

Optionally the option "no\_update" may be true, in which case the question will not be updated if it has already been set.

See the synopsis for examples.
