    task 'mytask', sub {
      my $parameters = shift;
      my $parameter1_value = $parameters->{parameter1};
      my $parameter2_value = $parameters->{parameter2};
    };

Then you can run mytask from CLI like this:

    rex -H hostname mytask --parameter1=value1 --parameter2=value2
