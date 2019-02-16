---
title: How do I run a local script on the remote under a different user?
---

Given the same scenario as above, but with the additional requirement to run the script as a different user, the solution looks like below:

    use Rex::Misc::ShellBlock;
    task "myexec", sub {
      sudo {
        command => sub {
          shell_block template('files/script');
        },
        user    => 'root'
      };
    };
