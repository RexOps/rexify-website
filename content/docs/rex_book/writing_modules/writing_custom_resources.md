---
title: Writing custom resources
---

Resoures are the units that are responsible to manage your configurations. 
Resources have a state. Compared to remote execution functions, that means, 
that a resource is only applied if the remote system is not in the specific
state.

Rex has simple remote execution functions (like `mkdir`, `is_dir`, `is_file`
and more). But it has also resources (like `file`, `pkg`, `service` and more).

Currently the resources and remote execution functions are mostly all in the
`Rex::Commands` namespace but in the next major release (2.0) resources will
have their own namespace (`Rex::Resource`).

Every command that has the option `ensure` is a resource.

Another difference between resources and remote execution functions is that
resources will be reported (if you are using the reporting feature) and have an
`on_change` attribute .


## Writing Resources for Rex 1.x (1.3+)

### Architecture of a Resource

A resource always exists of at least 2 files. The module which creates the
resource definition and exports the function (if wanted).
And a so called *provider* which provides the functionality for a specific
implementation. For example the *firewall* resource has a provider for *ufw* 
and for *iptables*.

The resource definition defines the parameters which are valid for the resource,
load the wanted or auto-detected provider class and execute the requested 
state.

After the execution of the requested state it will also emit the change, so the
reporting module get notified.

### Hello World Resource

To build a new resource you first have to create a new Rex module. Todo this,
just create a new folder.

    $ mkdir -p lib/HelloWorld

Now we need to create 2 files. One *\_\_module\_\_.pm* for the resource definition
and one *meta.yml* where we can define the dependencies our resource will have.
This file is needed if you want to upload your module to a git server and share
it between projects.

In the *meta.yml* file you can just put the following lines.

    Name: HelloWorld
    Description: A hello world resource
    License: YourLicense
    # we don't require anything
    # Requires:

The *\_\_module\_\_.pm* file which creates the resource.

    ```perl
    package HelloWorld;
    
    use strict;
    use warnings;
    
    use Rex -minimal; # for Rex < 1.4 use Rex -base;
    use Rex::Resource::Common; # load resource functions
    
    # load the Gather functions, so we have the `operating_system` 
    # function.
    use Rex::Commands::Gather;
    
    use Carp;
    
    # list the available providers
    my $__provider = {
      default => "HelloWorld::greet::Provider::default",
      CentOS  => "HelloWorld::greet::Provider::centos",
    };
    
    # create a resource HelloWorld::greet
    resource "greet", sub {
      my $rule_name = resource_name;
    
      my $rule_config = {
        ensure  => param_lookup( "ensure", "present" ),
        message => param_lookup( "message", "<default value>" ),
      };
    
      # get the right provider if it is not defined via the operating system
      # and the list from above.
      my $provider =
        param_lookup( "provider", case ( lc(operating_system), $__provider ) );
    
      # load the provider class
      $provider->require;
      
      # create a new instance of the provider class
      my $provider_o = $provider->new();
    
      # and execute the requested state.
      if ( $rule_config->{ensure} eq "present" ) {
        if ( $provider_o->present($rule_config) ) {
          emit created, "HelloWorld::greet resource created.";
        }
      }
      elsif ( $rule_config->{ensure} eq "absent" ) {
        if ( $provider_o->absent($rule_config) ) {
          emit removed, "HelloWorld::greet resource removed.";
        }
      }
      else {
        die "Error: $rule_config->{ensure} not a valid option for 'ensure'.";
      }
    
    };
    
    1; # this need to be the last line in the file
    ```

Now, after creating the resource definition we need to create our providers.
To do so, you need to create the following directory.

    $ mkdir -p lib/HelloWorld/greet/Provider

And place the two providers inside this directory.

    $ touch lib/HelloWorld/greet/Provider/default.pm
    $ touch lib/HelloWorld/greet/Provider/centos.pm

In this example we will create the *default.pm* provider and the *centos.pm*
provider which will just inherit every method from the *default.pm* provider.

In Rex < 2.0 we don't use any object system for perl so we need to create the
bare class by our self.

    ```perl
    # File: lib/HelloWorld/greet/Provider/default.pm
    package HelloWorld::greet::Provider::default;
    
    use strict;
    use warnings;
    
    use Rex::Commands::File;
    
    # the constructor
    sub new {
      my $that  = shift;
      my $proto = ref($that) || $that;
      my $self  = {@_};
    
      bless( $self, $proto );
    
      return $self;
    }
    
    # the ensure methods
    sub present {
      my ( $self, $rule_config ) = @_;
      
      my $changed = 0;
      
      file "/etc/motd",
        content => $rule_config->{message},
        owner   => "root",
        group   => "root",
        mode    => '0644',
        on_change => sub { $changed = 1; };
        
      return $changed;
    }
    
    sub absent {
      my ( $self, $rule_config ) = @_;
    
      my $changed = 0;
      
      file "/etc/motd",
        ensure    => "absent",
        on_change => sub { $changed = 1; };
        
      return $changed;
    }
    
    1; # this need to be the last line in the file
    ```

The next file is the *centos* provider. We will just inherit from the *default*
provider without overriding any functions. This is just for demonstration 
purpose how to do inheritance.

    ```perl
    # File: lib/HelloWorld/greet/Provider/centos.pm
    package HelloWorld::greet::Provider::centos;
    
    use strict;
    use warnings;
    
    use Rex::Commands::File;
    use parent qw(HelloWorld::greet::Provider::default);
    
    # the constructor
    sub new {
      my $that  = shift;
      my $proto = ref($that) || $that;
      
      # here we call the constructor of the parent class
      my $self  = $proto->SUPER::new(@_);
    
      bless( $self, $proto );
    
      return $self;
    }
    
    1; # this need to be the last line in the file
    ```


### Using your resource

After creating your module with the `greet` resource you can `use` this 
resource in your `Rexfile`.

    ```perl
    # Rexfile
    use Rex -feature => ['1.4'];
    use HelloWorld;
    
    group myservers => "srv[01..10]";
    
    task "prepare", group => "myservers", sub {
      HelloWorld::greet "mygreeting",
        message => "Welcome to my server",
        ensure  => "present",
        on_change => sub {
          say "server greeting has changed.";
        };
    };
    ```

