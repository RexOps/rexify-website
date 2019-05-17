---
title: A word on backward compatibility
---

Everyone knows the pain if something gets deprecated and one have to port his old (and stable) code to a new version of a library or a framework. There is enough work to do instead of fixing code to work with newer versions of them.

So there is one premise new versions of Rex has to fulfill. They must be backward compatible.

I know this might be impossible in the one or other way, but to minimize this danger there is a thing called feature flags. If there is the need to break backward compatibility in favor of a new feature there will be a feature flag for this change. And only if this feature flag gets enabled in the Rexfile it will break compatibility.

So the default is always to be compatible.

If you have a problem that occurs after an update, it is considered as a bug. Please report this bug in our issue tracker.

## Feature flags

This is the current list of feature flags:

| **Flag**                               | **Since** | **Description** |
|----------------------------------------|-----------|-----------------|
| 1.3                                    | 1.3       | Activating the new template engine by default. |
| no\_template\_ng                       | 1.3       | Disabling the new template engine. |
| 1.0                                    | 1.0       | Disabling usage of a tty. This increases compatibility for remote execution. Furthermore, all features from earlier versions are activated. |
| no\_autodie                            | 1.0       | Will disable autodie feature. |
| template\_ng                           | 0.56      | Enabling the new template engine (better error reporting, etc.) |
| 0.56                                   | 0.56      | Will activate autodie feature. Furthermore, all features from earlier versions are activated. |
| autodie                                | 0.56      | Will enable autodie feature: die on all failed [filesytem commands](../../api/Rex/Commands/Fs.pm.html) |
| 0.55                                   | 0.55      | Will activate using Net::OpenSSH by default if present. Furthermore, all features from earlier versions are activated. |
| 0.54                                   | 0.54      | Will activate checking services for existence before trying to manipulate them, and set() will overwrite already existing values (instead of concatenating). Furthermore, all features from earlier versions are activated. |
| 0.53                                   | 0.53      | Will activate register\_cmdb\_top\_scope. And all things 0.51 and down activated. |
| register\_cmdb\_top\_scope             | 0.53      | Will register all cmdb top scope variables automatically in the templates. |
| 0.51                                   | 0.51      | Will load Rex::Constants and the CMDB by default. And all things 0.47 and down activated. |
| no\_autodie                            | 1.0       | Will disable autodie feature. |
| no\_path\_cleanup                      | 0.44      | Rex cleans the path before executing a command. With this feature Rex doesn't cleanup the path. |
| verbose\_run                           | 0.47      | Explicitly output "Successfully executed" or "Error executing" messages for run() commands. |
| source\_profile                        | 0.44      | Source $HOME/.profile before running a command. |
| source\_global\_profile                | 0.44      | Source /etc/profile before running a command. |
| exec\_autodie                          | 0.44      | If you execute a command with run() Rex will die() if the command returns a RETVAL != 0. |
| exec\_and\_sleep                       | 0.43      | Sometimes some commands that fork away didn't keep running. With this flag rex will wait a few ms before exiting the shell. |
| disable\_strict\_host\_key\_checking   | 0.43      | Disabling strict host key checking for openssh connection mode. |
| reporting                              | 0.43      | Enable reporting |
| empty\_groups                          | 0.42      | Enable usage of empty groups. |
| use\_server\_auth                      | 0.42      | Enable the usage of special authentication options for servers. |
| tty                                    | 1.0       | Enable pty usage for ssh connections. (Default) |
| no\_tty                                | 0.41      | Disable pty usage for ssh connections. |
| no\_local\_template\_vars              | 0.40      | Use global variables in templates |
| sudo\_without\_sh                      | 0.40      | Run sudo commands directly without the use of 'sh'. This might break things. |
| sudo\_without\_locales                 | 0.40      | Run sudo commands without locales. this will break things if you don't use english locales. |
| exit\_status                           | 0.39      | This option tells Rex to return a non zero value on exit if a task fails. |
| 0.35                                   | 0.35      | This option enables the features of 0.31 and the possibility to call tasks as a functions without the need to use a hash reference for the parameters. |
| 0.31                                   | 0.31      | To enable special authentication options for a server group. This will overwrite the default authentication options for a task. |

 

## Howto enable Feature Flags

You can enable feature flags in your Rexfile with the following code:

    # Rexfile
    use Rex -feature => ['0.31'];

or even multiple ones like this:

    # Rexfile
    use Rex -feature => [qw(exec_autodie source_profile)];

 

 
