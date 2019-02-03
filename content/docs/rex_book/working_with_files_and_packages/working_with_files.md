One task in configuration management is managing files and keeping them in a consistant state. Rex gives you some easy to use functions to work with files.

## Simple changes

If you need to verify that a given line exists or gets removed from a file you can use append\_if\_no\_such\_line and delete\_lines\_according\_to.

    # Rexfile
    task "setup", sub {
      append_if_no_such_line "/etc/modules", "loop";
    };

This code will just append the line loop to /etc/modules if it doesn't exists.

### Using regular expression to match the line

It is also possible to define more complex rules. For example if you want to use a regular expression.

    # Rexfile
    task "setup", sub {
      append_if_no_such_line "/etc/modprobe.d/thinkfan.conf",
        line   => "options thinkpad_acpi fan_control=1",
        regexp => qr{thinkpad_acpi};
    };

### Using a template and executing extra code if the file changed

If you need to add more than one line to a file or need to add dynamic content to it, you can also use the template() function to do this.

You can also execute code if the file was changed, for example to restart services.

    # Rexfile
    task "setup", sub {
      append_if_no_such_line "/etc/nagios/hosts.d/frontends.cfg",
        line      => template("templates/nagios/host.cfg.tpl", %tpl_variables),
        regexp    => qr/\s*host_name\s*$host/,
        on_change => sub { service nagios => "reload"; };
    };

### Deleting lines

If you need to remove a line you can use delete\_lines\_according\_to.

    # Rexfile
    task "setup", sub {
      delete_lines_according_to qr{loop}, "/etc/modules",
        on_change => sub { say "file was modified."; };
    };

## Managing files with snippets

Sometimes you need to create large configuration files because you don't have the ability to use conf.d folders.

You can do this by creating the snippets and concatenating them at the end.

For this you can use the Rex::Commands::Concat module from http://modules.rexify.org/module/Rex::Commands::Concat.

    # Rexfile
    use Rex -feature => ['1.0'];
    use Rex::Commands::Concat;

    task "prepare", sub {
      concat_fragment "config-header",
        target  => "/etc/some.conf",
        content => "# managed by Rex\n",
        order   => "01";

      concat_fragment "listen-entry",
        target  => "/etc/some.conf",
        content => "Listen *:80\n",
        order   => "20";
    };

    task "setup", sub {
      concat "/etc/some.conf",
        ensure    => "present",
        owner     => "root",
        group     => "root",
        mode      => 644,
        on_change => sub { say "changed..."; };
    };

You can create as many concat\_fragment() as you need. And you can create them anywhere you want. At the end of your code you have to call the concat() resource to generate the file out of all the fragments that have been written so far.

## The file() resource

If you want to manage complete files you can use the file() resource to do so. The file() resource supports also setting the permissions and executing actions for changes.

    # Rexfile
    use Rex -feature => ['1.0'];

    task "setup", sub {
      file "/etc/my.conf",
        source => "files/etc/my.conf";
    };

This example will just upload the file files/etc/my.conf to the server and stores it at /etc/my.conf.

You can also define the permissions for the file.

    # Rexfile
    use Rex -feature => ['1.0'];

    task "setup", sub {
      file "/etc/my.conf",
        source => "files/etc/my.conf",
        owner  => "root",
        group  => "root",
        mode   => 600;
    };

If you want to execute a command when the file was changed, you can use the on\_change option.

    # Rexfile
    use Rex -feature => ['1.0'];

    task "setup", sub {
      file "/etc/my.conf",
        source => "files/etc/my.conf",
        owner  => "root",
        group  => "root",
        mode   => 600,
        on_change => sub { service mysqld => "restart"; };
    };

This will restart the mysqld service if the file was modified.

### Supervising files

It is also possible to just supervise files if they are present or have special permissions. To do this, just create the file() resource without the source or content parameter.

    # Rexfile
    use Rex -feature => ['1.0'];

    task "setup", sub {
      file "/etc/my.conf",
        ensure => "present",
        owner  => "root",
        group  => "root",
        mode   => 600;
    };

 
