-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [SYNOPSIS](#SYNOPSIS)
-   [METHODS](#METHODS)
    -   [share](#share)

# NAME

Rex::Shared::Var - Share variables across Rex tasks

# DESCRIPTION

Share variables across Rex tasks with the help of Storable, using a `vars.db.$PID` file in the local directory, where `$PID` is the PID of the parent process.

# SYNOPSIS

     BEGIN {                           # put share in a BEGIN block
       use Rex::Shared::Var;
       share qw($scalar @array %hash); # share the listed variables
     }

# METHODS

## share

Share the passed list of variables across Rex tasks. Should be used in a `BEGIN` block.

     BEGIN {
       use Rex::Shared::Var;
       share qw($error_count);
     }

     task 'count', sub {
       $error_count += run 'wc -l /var/log/syslog';
     };

     after_task_finished 'count', sub {
       say "Total number of errors: $error_count";
     };
