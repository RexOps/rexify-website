-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [SYNOPSIS](#SYNOPSIS)
-   [EXPORTED FUNCTIONS](#EXPORTED-FUNCTIONS)
    -   [checkout($name, %data);](#checkout-name-data-)

# NAME

Rex::Commands::SCM - Sourcecontrol for Subversion and Git.

# DESCRIPTION

With this module you can checkout subversion and git repositories.

Version &lt;= 1.0: All these functions will not be reported.

All these functions are not idempotent.

# SYNOPSIS

     use Rex::Commands::SCM;
     
     set repository => "myrepo",
        url => 'git@foo.bar:myrepo.git';
     
     set repository => "myrepo2",
        url => "https://foo.bar/myrepo",
        type => "subversion",
        username => "myuser",
        password => "mypass";
     
     task "checkout", sub {
       checkout "myrepo";
     
       checkout "myrepo",
         path => "webapp";
     
       checkout "myrepo",
         path => "webapp",
         branch => 1.6;    # branch only for git
     
       checkout "myrepo2";
     };

# EXPORTED FUNCTIONS

## checkout($name, %data);

With this function you can checkout a repository defined with *set repository*. See Synopsis.
