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

Create a partition with the specified parameters:

ondisk  
The disk to be partitioned. Mandatory.

size  
Desired size of the partition in MB. It is mandatory to pass either a `size` or a `grow` parameter (but not both).

grow  
If `TRUE`, then the partition will take up all the available space on the disk. It is mandatory to pass either a `grow` or a `size` parameter (but not both).

type  
Partition type to be passed to `parted`'s `mkpart` command. Optional, defaults to `primary`.

boot  
Sets boot flag on the partition if `TRUE`. Optional, no boot flag is set by default.

fstype  
Create a filesystem after creating the partition. Optional, no filesystem is created by default.

label  
Label to be used with the filesystem. Optional, defaults to no label.

mount  
If `TRUE`, try to mount the partition after creating it. Optional, no mount is attempted by default.

mount\_persistent  
If `TRUE`, try to mount the partition after creating it, and also register it in `/etc/fstab`. Optional, no mount or `/etc/fstab` manipulation is attempted by default.

vg  
Creates an LVM PV, then creates the specifed LVM VG (or extends it, if the VG already exists). Needs `ondisk`.

Examples:

     partition "/",
       fstype => "ext3",
       size   => 15000,
       ondisk => "sda",
       type   => "primary";
     
     partition "none",
       type   => "extended",
       ondisk => "sda",
       grow   => 1,
       mount  => TRUE,
     
     partition "swap",
       fstype => "swap",
       type   => "logical",
       ondisk => "sda",
       size   => 8000;

     partition "/",
       fstype => "ext3",
       size   => 10000,
       ondisk => "sda",
       vg     => "vg0";
