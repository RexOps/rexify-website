You can use the ShellBlock module. This module can be installed by running:

    $ rexify --use Rex::Misc::ShellBlock

Then, you can run your shell code remotely as:

    use Rex::Misc::ShellBlock;

    task "myexec", sub {
      shell_block <<EOF;
        echo "hi"
    EOF
    };

See the linked documentation page for how to use this module with Perl, Python, or other languages.
