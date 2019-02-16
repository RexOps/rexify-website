---
title: Inventory.pm
---

-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [SYNOPSIS](#SYNOPSIS)
-   [EXPORTED FUNCTIONS](#EXPORTED-FUNCTIONS)
    -   [inventory](#inventory)

# NAME

Rex::Commands::Inventory - Get an inventory of your systems

# DESCRIPTION

With this module you can get an inventory of your system.

All these functions will not be reported. These functions don't modify anything.

# SYNOPSIS

     use Data::Dumper;
     task "inventory", "remoteserver", sub {
       my $inventory = inventory();
       print Dumper($inventory);
     };

# EXPORTED FUNCTIONS

## inventory

This function returns a hashRef of all gathered hardware. Use the Data::Dumper module to see its structure.

     task "get_inventory", sub {
       my $inventory = inventory();
       print Dumper($inventory);
     };
