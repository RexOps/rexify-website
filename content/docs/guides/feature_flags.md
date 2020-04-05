---
title: A word on backward compatibility
---

Like any good software project, Rex improves with each new version. This is a
good thing. But it would be a bummer if the Rexfiles you wrote broke after
upgrading to a new version of Rex. You've got better things to do than go back
and fix Rexfiles to make them compatible with new versions. So Rex does its best
to ensure newer versions of Rex are backward compatible with your existing
Rexfiles by implementing *feature flags,* which is a small bit of code you place in
your Rexfile to break backward compatibility.

## How Feature Flags Work

By default, all old Rex features will work with your Rexfile. If you want to
take advantage of new features, you must add a feature flag to your Rexfile to
tell Rex that you don't mind breaking backward compatibility and removing older
features. In other words, the default is for your Rexfile to always to be
backward compatible unless you add a feature flag to tell it otherwise. As a
general rule of thumb, when creating a new Rexfile, you should use a feature
flag to turn off backward compatibility.

If your Rexfiles are broken by an update, this is considered to be a bug.
Please report this bug in our issue tracker.

## Feature flags

This is the current list of feature flags:

| **Flag**                             | **Since** | **Description**                                                                                                                                                                                                             |
|--------------------------------------|-----------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 1.4                                  | 1.4       | Break all backward compatibility                                                                                                                                                                                            |
| no\_task\_chaining\_cmdline\_args    | 1.4       | Disable per-task argument parsing                                                                                                                                                                                           |
| task\_chaining\_cmdline\_args        | 1.4       | Enable per-task argument parsing: `rex --rex --args task1 --task1arg=value task2 --task2arg` so task1 only gets `task1arg` and task2 only gets `task2arg`.                                                                  |
| 1.3                                  | 1.3       | Activating the new template engine by default.                                                                                                                                                                              |
| no\_template\_ng                     | 1.3       | Disabling the new template engine.                                                                                                                                                                                          |
| 1.0                                  | 1.0       | Disabling usage of a tty. This increases compatibility for remote execution. Furthermore, all features from earlier versions are activated.                                                                                 |
| no\_autodie                          | 1.0       | Will disable autodie feature.                                                                                                                                                                                               |
| tty                                  | 1.0       | Enable pty usage for ssh connections. (Default)                                                                                                                                                                             |
| template\_ng                         | 0.56      | Enabling the new template engine (better error reporting, etc.)                                                                                                                                                             |
| 0.56                                 | 0.56      | Will activate autodie feature. Furthermore, all features from earlier versions are activated.                                                                                                                               |
| autodie                              | 0.56      | Will enable autodie feature: die on all failed [filesytem commands](https://metacpan.org/pod/Rex::Commands::Fs)                                                                                                             |
| 0.55                                 | 0.55      | Will activate using Net::OpenSSH by default if present. Furthermore, all features from earlier versions are activated.                                                                                                      |
| 0.54                                 | 0.54      | Will activate checking services for existence before trying to manipulate them, and set() will overwrite already existing values (instead of concatenating). Furthermore, all features from earlier versions are activated. |
| 0.53                                 | 0.53      | Will activate register\_cmdb\_top\_scope. And all things 0.51 and down activated.                                                                                                                                           |
| register\_cmdb\_top\_scope           | 0.53      | Will register all cmdb top scope variables automatically in the templates.                                                                                                                                                  |
| 0.51                                 | 0.51      | Will load Rex::Constants and the CMDB by default. And all things 0.47 and down activated.                                                                                                                                   |
| disable\_taskname\_warning           | 0.47      | Disable warning about invalid task names (they should match `/^[a-zA-Z_][a-zA-Z0-9_]*$/`)                                                                                                                                   |
| verbose\_run                         | 0.47      | Explicitly output "Successfully executed" or "Error executing" messages for run() commands.                                                                                                                                 |
| no\_cache                            | 0.46      | Disable caching (like discovery results of remote OS, hardware, shell, etc.)                                                                                                                                                |
| no\_path\_cleanup                    | 0.44      | Rex cleans the path before executing a command. With this feature Rex doesn't cleanup the path.                                                                                                                             |
| source\_profile                      | 0.44      | Source $HOME/.profile before running a command.                                                                                                                                                                             |
| source\_global\_profile              | 0.44      | Source /etc/profile before running a command.                                                                                                                                                                               |
| exec\_autodie                        | 0.44      | If you execute a command with run() Rex will die() if the command returns a RETVAL != 0.                                                                                                                                    |
| exec\_and\_sleep                     | 0.43      | Sometimes some commands that fork away didn't keep running. With this flag rex will wait a few ms before exiting the shell.                                                                                                 |
| disable\_strict\_host\_key\_checking | 0.43      | Disabling strict host key checking for openssh connection mode.                                                                                                                                                             |
| reporting                            | 0.43      | Enable reporting                                                                                                                                                                                                            |
| empty\_groups                        | 0.42      | Enable usage of empty groups.                                                                                                                                                                                               |
| use\_server\_auth                    | 0.42      | Enable the usage of special authentication options for servers.                                                                                                                                                             |
| no\_tty                              | 0.41      | Disable pty usage for ssh connections.                                                                                                                                                                                      |
| no\_local\_template\_vars            | 0.40      | Use global variables in templates                                                                                                                                                                                           |
| sudo\_without\_sh                    | 0.40      | Run sudo commands directly without the use of 'sh'. This might break things.                                                                                                                                                |
| sudo\_without\_locales               | 0.40      | Run sudo commands without locales. This will break things if you don't use English locales.                                                                                                                                 |
| exit\_status                         | 0.39      | This option tells Rex to return a non zero value on exit if a task fails.                                                                                                                                                   |
| 0.35                                 | 0.35      | This option enables the features of 0.31 and the possibility to call tasks as a functions without the need to use a hash reference for the parameters.                                                                      |
| 0.31                                 | 0.31      | To enable special authentication options for a server group. This will overwrite the default authentication options for a task.                                                                                             |

## Howto enable Feature Flags

You can enable feature flags in your Rexfile with the following code:

    ```perl
    # Rexfile
    use Rex -feature => ['1.4']; # breaks all backward compatibility
    ```

or even multiple ones like this:

    ```perl
    # Rexfile
    use Rex -feature => [qw(exec_autodie source_profile)]; # enable the exec_autodie and source_profile features
    ```
