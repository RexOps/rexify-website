-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [SYNOPSIS](#SYNOPSIS)
-   [EXPORTED FUNCTIONS](#EXPORTED-FUNCTIONS)
    -   [kmod($action =&gt; $module)](#kmod-action-module-)

# NAME

Rex::Commands::Kernel - Load/Unload Kernel Modules

# DESCRIPTION

With this module you can load and unload kernel modules.

Version &lt;= 1.0: All these functions will not be reported.

All these functions are not idempotent.

# SYNOPSIS

     kmod load => "ipmi_si";
     
     kmod unload => "ipmi_si";

# EXPORTED FUNCTIONS

## kmod($action =&gt; $module)

This function loads or unloads a kernel module.

     task "load", sub {
       kmod load => "ipmi_si";
     };
     
     task "unload", sub {
       kmod unload => "ipmi_si";
     };

If you're using NetBSD or OpenBSD you have to specify the complete path and, if needed the entry function.

     task "load", sub {
       kmod load => "/usr/lkm/ntfs.o";
       kmod load => "/path/to/module.o", entry => "entry_function";
     };
