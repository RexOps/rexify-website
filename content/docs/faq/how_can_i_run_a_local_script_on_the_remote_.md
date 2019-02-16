---
title: How can I run a local script on the remote?
---

If you have a local script 'files/script', you can run it on the remote using the ShellBlock module referred to in the FAQ above. After you install as pointed out above, you can run the script remotely with the command:

    use Rex::Misc::ShellBlock;
    task "myexec", sub {
      shell_block template('files/script');
    };
