---
title: Executing a command and parsing its output
---

### run($command, %options)

Run a remote command and returns its output.

#### Options

-   cwd - Work directory for the command.
-   only\_if - Executes the command only if the condition completes successfully.
-   unless - Executes the command only unless the condition completes successfully.
-   only\_notified - queues the command, to be executed upon notification.
-   env - sets environment variables for the command.
-   timeout - try to terminate the command after the given amount of seconds.
-   auto\_die - die if the command returns with a non-zero exit code.
-   command - the command that should be executed.
-   creates - If the file given with this option already exists, the command won't be executed.

#### Example to just run a command if a file doesn't exists

    run "/tmp/install_service.sh",
      creates => "/opt/myservice/conf.xml";

#### Example to run a command and get its output

    my @output_lines = run "df -h";

 
