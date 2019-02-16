---
title: Notify.pm
---

-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [SYNOPSIS](#SYNOPSIS)
-   [EXPORTED FUNCTIONS](#EXPORTED-FUNCTIONS)
    -   [notify($resource\_type, $resource\_name)](#notify-resource_type-resource_name-)

# NAME

Rex::Commands::Notify - Notify a resource to execute.

# DESCRIPTION

This module exports the notify() function.

# SYNOPSIS

     notify "run", "extract-archive";
     notify $type, $resource_name;

# EXPORTED FUNCTIONS

## notify($resource\_type, $resource\_name)

This function will notify the given $resource\_name of the given $resource\_type to execute.
