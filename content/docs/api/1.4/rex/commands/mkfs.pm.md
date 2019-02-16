---
title: Mkfs.pm
---

-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [SYNOPSIS](#SYNOPSIS)
-   [EXPORTED FUNCTIONS](#EXPORTED-FUNCTIONS)
    -   [mkfs($devname, %option)](#mkfs-devname-option-)

# NAME

Rex::Commands::Mkfs - Create filesystems

# DESCRIPTION

With this module you can create filesystems on existing partitions and logical volumes.

# SYNOPSIS

     use Rex::Commands::Mkfs;

# EXPORTED FUNCTIONS

## mkfs($devname, %option)

Create a filesystem on device $devname.

     mkfs "sda1",
       fstype => "ext2",
       label  => "mydisk";

     mkfs "sda2",
       fstype => "swap";
