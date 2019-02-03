-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [SYNOPSIS](#SYNOPSIS)
-   [EXPORTED FUNCTIONS](#EXPORTED-FUNCTIONS)
    -   [is\_defined($variable, $default\_value)](#is_defined-variable-default_value-)

# NAME

Rex::Template - Simple Template Engine.

# DESCRIPTION

This is a simple template engine for configuration files.

# SYNOPSIS

     my $template = Rex::Template->new;
     print $template->parse($content, \%template_vars);

# EXPORTED FUNCTIONS

## is\_defined($variable, $default\_value)

This function will check if $variable is defined. If yes, it will return the value of $variable, otherwise it will return $default\_value.

You can use this function inside your templates.

     ServerTokens <%= is_defined($::server_tokens, "Prod") %>
