-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [DEPENDENCIES](#DEPENDENCIES)
-   [SYNOPSIS](#SYNOPSIS)
-   [EXPORTED FUNCTIONS](#EXPORTED-FUNCTIONS)
    -   [sync($source, $dest, $opts)](#sync-source-dest-opts-)

# NAME

Rex::Commands::Rsync - Simple Rsync Frontend

# DESCRIPTION

With this module you can sync 2 directories via the *rsync* command.

Version &lt;= 1.0: All these functions will not be reported.

All these functions are not idempotent.

# DEPENDENCIES

Expect  
The *Expect* Perl module is required to be installed on the machine executing the rsync task.

rsync  
The *rsync* command has to be installed on both machines involved in the execution of the rsync task.

# SYNOPSIS

     use Rex::Commands::Rsync;

     sync "dir1", "dir2";

# EXPORTED FUNCTIONS

## sync($source, $dest, $opts)

This function executes rsync to sync $source and $dest.

If you want to use sudo, you need to disable *requiretty* option for this user. You can do this with the following snippet in your sudoers configuration.

     Defaults:username !requiretty

UPLOAD - Will upload all from the local directory *html* to the remote directory */var/www/html*.  
     task "sync", "server01", sub {
       sync "html/*", "/var/www/html", {
        exclude => "*.sw*",
        parameters => '--backup --delete',
       };
     };

     task "sync", "server01", sub {
       sync "html/*", "/var/www/html", {
        exclude => ["*.sw*", "*.tmp"],
        parameters => '--backup --delete',
       };
     };

DOWNLOAD - Will download all from the remote directory */var/www/html* to the local directory *html*.  
     task "sync", "server01", sub {
       sync "/var/www/html/*", "html/", {
        download => 1,
        parameters => '--backup',
       };
     };
