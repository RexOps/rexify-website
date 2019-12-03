---
title: Just enough Perl for Rex
---

Perl is a scripting language designed to keep easy things easy, and make hard things possible. In this tutorial you will learn just enough Perl to write your own Rex tasks.

If you have suggestions or wishes, tell us on IRC, or just send a pull request against the GitHub repository.

## Variables

### Scalar variables

Scalars can contain single items, like strings, numbers, objects or references.

    ```perl
    my $name  = 'John';     # this is a string
    my $age   = 28;         # this is a number (integer)
    my $float = 28.5;       # also a number, but a float
    my $car   = Car->new(); # this is an object from the class Car
    ```

### Array variables

Arrays are lists of scalars. Like a grocery list.

    ```perl
    my @names  = ( 'John', 'Fred', 'Charley' );
    my @to_buy = qw( Cheese Butter Salt );     # qw() quotes the words
    ```

To access an array element you have to use its index, which starts at zero:

    ```perl
    say 'First name is: ' . $names[0];
    say 'Last name is: ' . $name[2];
    say 'Also the last name: ' . $name[-1];
    ```

Split a string into an array:

    ```perl
    my $string = 'John,Fred,Charley';
    my @names  = split( /,/, $string );
    ```

Join the items of an array into a string:

    ```perl
    my @names  = qw( John Fred Charley );
    my $string = join( ',', @names );    # -> John,Fred,Charley
    ```

If you want to iterate over an array, do it like this:

    ```perl
    for my $name (@names) {
        say "Current name: $name"; # double quotes make variables interpolated
    }
    ```

### Hash variables

Hashes are like arrays, but with named indexes, called keys.

    ```perl
    my %person = (
        name => 'John',
        age  => 28,    # good practice to keep a trailing comma
    );
    ```

To access a hash element you have to use its key:

    ```perl
    say 'Name: ' . $person{'name'};
    say 'Age: ' . $person{age}; # perl can autoquote simple key names for you
    ```

If you want to iterate over a hash, do it like this:

    ```perl
    for my $key ( keys %person ) {
        say "key: $key -> value: " . $person{$key};
    }
    ```

But remember an important note: hashes are always unsorted.

## Conditional statements

    ```perl
    if ( $name eq 'John' ) {
        say 'Hello, my name is John!';
    }
    else {
        say 'Well, my name is not John...';
    }
    
    if ( $name ne 'John' ) {
        say 'Well, my name is not John...';
    }
    else {
        say 'Hello, my name is John!';
    }
    
    if ( $age < 30 ) {
        say 'I am younger than 30.';
    }
    elsif ( $age >= 30 && $age <= 50 ) {
        say 'Well, I am between 30 and 50.';
    }
    else {
        say 'I am older than 50.';
    }
    ```

## Loops

    ```perl
    for my $num ( 1 .. 5 ) {
        say "> $num";
    }
    
    # looping over an array
    for my $item (@array) {
        say "> $item";
    }
    ```

## Regular expressions

    ```perl
    my $name = 'John';
    
    if ( $name =~ m/john/ ) { # will _not_ match, because the 'J' in $name is uppercase
    }
    
    if ( $name =~ m/john/i ) { # _will_ match, because we use the 'i' modifier for case-insensitive matching
    }
    
    $name =~ s/john/Fred/i; # this will replace the first match of 'john' (regardless of its case) with 'Fred'
    $name =~ s/john/Fred/ig; # this will replace all matches of 'john' (regardless of its case) with 'Fred'
    ```

## Subroutines

    ```perl
    sub my_function { # define the subroutine called 'my_function'
    }
    
    sub my_function2 { # @_ contains the parameters passed to the subroutine
        my ( $param1, $param2 ) = @_;
    }
    
    my_function();     # call the function 'my_function'
    my_function; # also calls 'my_function', but harder to read due to missing parentheses
    &my_function; # also calls 'my_function', but with a deprecated old notation
    
    my_function2( 'john', 28 ); # call 'my_function2' with 2 parameters
    my_function2 'john', 28; # does the same, but harder to read due to missing parentheses
    ```

## Useful helpers

Dump the content of a scalar, array or hash:

    ```perl
    use Data::Dumper;
    say Dumper($scalar);
    say Dumper(@array);
    say Dumper(%hash);
    ```

## More documentation

If you want to learn more Perl you can find a great online tutorial on [Perl Maven](http://perlmaven.com/perl-tutorial).
