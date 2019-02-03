-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [SYNOPSIS](#SYNOPSIS)
-   [EXPORTED FUNCTIONS](#EXPORTED-FUNCTIONS)
    -   [groups\_yaml($file)](#groups_yaml-file-)

# NAME

Rex::Group::Lookup::YAML - read hostnames and groups from a YAML file

# DESCRIPTION

With this module you can define hostgroups out of an yaml file.

# SYNOPSIS

     use Rex::Group::Lookup::YAML;
     groups_yaml "file.yml";

# EXPORTED FUNCTIONS

## groups\_yaml($file)

With this function you can read groups from yaml files.

File Example:

webserver: - fe01 - fe02 - f03 backends: - be01 - be02 - f03

     groups_yaml($file);
     
     groups_yaml($file, create_all_group => TRUE);
