-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [EXPORTED METHODS](#EXPORTED-METHODS)
    -   [register\_set\_handler($handler\_name, $code)](#register_set_handler-handler_name-code-)
    -   [register\_config\_handler($topic, $code)](#register_config_handler-topic-code-)

# NAME

Rex::Config - Handles the configuration.

# DESCRIPTION

This module holds all configuration parameters for Rex.

With this module you can specify own configuration parameters for your modules.

# EXPORTED METHODS

## register\_set\_handler($handler\_name, $code)

Register a handler that gets called by *set*.

     Rex::Config->register_set_handler("foo", sub {
       my ($value) = @_;
       print "The user set foo -> $value\n";
     });

And now you can use this handler in your *Rexfile* like this:

     set foo => "bar";

## register\_config\_handler($topic, $code)

With this function it is possible to register own sections in the users config file ($HOME/.rex/config.yml).

Example:

     Rex::Config->register_config_handler("foo", sub {
      my ($param) = @_;
      print "bar is: " . $param->{bar} . "\n";
     });

And now the user can set this in his configuration file:

     base:
       user: theuser
       password: thepassw0rd
     foo:
       bar: baz
