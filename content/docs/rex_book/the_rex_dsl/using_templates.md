A template is a text file containing special variables or perl code inside it. So with this technique you can generate dynamic configuration files. For example if you want to configure apache only to listen on a special ethernet device (eth0 for example) templates are what you need.

The default template engine is a special Rex template engine. The syntax is a bit like php or erb. But you can use any template engine you want. Just browse cpan and find one you like.

For example:

    Hello <%%= $name %>!

If $name contains "World" this template would result in the string Hello World!. This is very usefull if you have to maintain a large set of nearly identical configuration files.

## Working with a template

First you have to create it

    $ mkdir files
    $ vim files/my.cnf.tpl

    [mysqld]
    datadir                 = /var/lib/mysql
    socket                  = /var/run/mysqld/mysqld.sock
    user                    = mysql
    # Disabling symbolic-links is recommended to prevent assorted security risks
    symbolic-links          = 0
    datadir                 = /var/lib/mysql
    tmpdir                  = /tmp
    skip-external-locking
    max_allowed_packet      = 64M
    thread_stack            = 192K
    max_connections         = <%%= exists $conf->{"max_connections"} ? $conf->{"max_connections"} : "1000" %>

    max_connect_errors      = 1000
    table_cache             = <%%= exists $conf->{"table_cache"} ? $conf->{"table_cache"} : "5000" %>
    table_open_cache        = <%%= exists $conf->{"table_open_cache"} ? $conf->{"table_open_cache"} : "5000" %>
    thread_concurrency      = 10

    #
    # ... and more ...
    #

Than you can reference on it from within your Rexfile.

    use Rex -feature => ['1.0'];

    user "root";
    key_auth;

    group databases=> "mydb01", "mydb02";

    task "prepare_databases", group => "databases", sub {
       file "/etc/my.cnf",
          owner   => "root",
          group   => "root",
          mode    => "644",
          content => template("files/my.cnf.tpl", conf => {
                                 max_connections => "500",
                                 table_cache     => "2500",
                              });
    };

## Inline Templates

When you want to deliver a rexfile that includes the templates, you can use inline templates. To use this feature, you have to use the \_\_DATA\_\_ section of your rexfile. You can also define several templates in that section:

### Using a single inline template

    use Rex -feature => ['1.0'];

    task tempfiles => sub {
        file '/tmp/test.txt' =>
            content => template(
                '@test',
                test => {
                    author => 'reneeb',
                    target => 'rex',
                },
            ),
            chmod => 644,
        ;
    };

    __DATA__
    @test
    This is a test written by <%%= $test->{author} %>
    for a project called <%%= $test->{target} %>
    @end

The `__DATA__` section is the last section of the Rexfile. The first parameter of the template method call gets the name of the inline template. Note that names of inline templates begin with `@`.

Rex knows that it has to look up the template in the `__DATA__` section of the file where template was called. Within the section the template starts with its name (here: `@test`) and then follows the template text.

### Using multiple inline templates

    use Rex -feature => ['1.0'];
    task tempfiles => sub {
        file '/tmp/test.txt' =>
            content => template(
                '@test',
                test => {
                    author => 'reneeb',
                    target => 'rex',
                },
            ),
            chmod => 644,
        ;

        file '/tmp/rex.txt' =>
            content => template(>
                '@rex',
                test => {
                    author => 'krimdomu',
                    target => 'rex',
                },
            ),
            chmod => 644,
        ;
    };

    __DATA__
    @test
    This is a test written by <%%= $test->{author} %>
    for a project called <%%= $test->{target} %>
    @end

    @rex
    Contribution by <%%= $test->{author} %>
    for a project called <%%= $test->{target} %>
    @end

Now we just look at the `__DATA__` section: You notice the token `@end`. This is used to separate the templates. At the end of each template (except for the last one) this token is needed. Otherwise Rex will use everything up to the first `@end` as the template which is most likely too much.
