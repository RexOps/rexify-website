---
title: LVM.pm
---

-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [SYNOPSIS](#SYNOPSIS)
-   [EXPORTED FUNCTIONS](#EXPORTED-FUNCTIONS)
    -   [pvs](#pvs)
    -   [vgs](#vgs)
    -   [lvs](#lvs)

# NAME

Rex::Commands::LVM - Get LVM Information

# DESCRIPTION

With this module you can get information of your lvm setup.

Version &lt;= 1.0: All these functions will not be reported.

All these functions are not idempotent.

# SYNOPSIS

     use Rex::Commands::LVM;
     
     my @physical_devices = pvs;
     my @volume_groups = vgs;
     my @logical_volumes = lvs;

# EXPORTED FUNCTIONS

## pvs

Get Information for all your physical volumes.

     use Data::Dumper;
     use Rex::Commands::LVM;
     
     task "lvm", sub {
       my @physical_volumes = pvs;
     
       for my $physical_volume (@physical_volumes) {
         say Dumper($physical_volume);
       }
     };

## vgs

Get Information for all your volume groups.

     use Data::Dumper;
     use Rex::Commands::LVM;
     
     task "lvm", sub {
       my @volume_groups = vgs;
     
       for my $volume_group (@volume_groups) {
         say Dumper($volume_group);
       }
     };

## lvs

Get Information for all your logical volumes.

     use Data::Dumper;
     use Rex::Commands::LVM;
     
     task "lvm", sub {
       my @logical_volumes = lvs;
     
       for my $logical_volume (@logical_volumes) {
         say Dumper($logical_volume);
       }
     };
