-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [SYNOPSIS](#SYNOPSIS)
-   [EXPORTED FUNCTIONS](#EXPORTED-FUNCTIONS)
    -   [clearpart($drive)](#clearpart-drive-)
    -   [partition($mountpoint, %option)](#partition-mountpoint-option-)

# NAME

Rex::Commands::Partition - Partition module

# DESCRIPTION

With this Module you can partition your harddrive.

Version &lt;= 1.0: All these functions will not be reported.

All these functions are not idempotent.

# SYNOPSIS

     use Rex::Commands::Partition;

# EXPORTED FUNCTIONS

## clearpart($drive)

Clear partitions on drive \`sda\`:

     clearpart "sda";

Create a new GPT disk label (partition table) on drive \`sda\`:

     clearpart "sda",
      initialize => "gpt";

If GPT initialization is requested, the \`bios\_boot\` option (default: TRUE) can also be set to TRUE or FALSE to control creation of a BIOS boot partition:

     clearpart "sda",
      initialize => "gpt",
      bios_boot => FALSE;

## partition($mountpoint, %option)

Create a partition with mountpoint $mountpoint.

     partition "/",
       fstype  => "ext3",
       size   => 15000,
       ondisk  => "sda",
       type   => "primary";
     
     partition "none",
       type  => "extended",
       ondisk => "sda",
       grow  => 1,
       mount  => TRUE,
     
     partition "swap",
       fstype => "swap",
       type  => "logical",
       ondisk => "sda",
       size  => 8000;
     
     partition "none",
       lvm   => 1,
       type  => "primary",
       size  => 15000,
       ondisk => "vda";
     
     partition "/",
       fstype => "ext3",
       size  => 10000,
       onvg  => "vg0";
