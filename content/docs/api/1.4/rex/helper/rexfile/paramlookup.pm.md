---
title: ParamLookup.pm
---

-   [NAME](#NAME)
-   [SYNOPSIS](#SYNOPSIS)
-   [LOOKUP](#LOOKUP)

# NAME

Rex::Helper::Rexfile::ParamLookup - A command to manage task parameters.

A command to manage task parameters. Additionally it register the parameters as template values.

This module also looks inside a CMDB (if present) for a valid key.

# SYNOPSIS

     task "setup", sub {
       my $var = param_lookup "param_name", "default_value";
     };

# LOOKUP

First *param\_lookup* checks the task parameters for a valid parameter. If none is found and if a CMDB is used, it will look inside the cmdb.

If your module is named "Rex::NTP" than it will first look if the key "Rex::NTP::param\_name" exists. If it doesn't exists it checks for the key "param\_name".
