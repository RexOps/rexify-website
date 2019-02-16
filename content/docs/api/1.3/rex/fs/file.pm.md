---
title: File.pm
---

-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [SYNOPSIS](#SYNOPSIS)
-   [CLASS METHODS](#CLASS-METHODS)
    -   [new](#new)
    -   [write($buf)](#write-buf-)
    -   [seek($offset)](#seek-offset-)
    -   [read($len)](#read-len-)
    -   [read\_all](#read_all)
    -   [close](#close)

# NAME

Rex::FS::File - File Class

# DESCRIPTION

This is the File Class used by *file\_write* and *file\_read*.

# SYNOPSIS

     use Rex::Interface::File;
     my $fh = Rex::Interface::File->create('Local');
     $fh->open( '<', 'filename' );

     my $file = Rex::FS::File->new(fh => $fh);
     $file->read($len);
     $file->read_all;
     $file->write($buf);
     $file->close;

# CLASS METHODS

## new

This is the constructor. You need to set the filehandle which the object should work on or pass a filename. If you pass a filehandle, it has to be a `Rex::Interface::File::*` object

     my $fh = Rex::Interface::File->create('Local');
     $fh->open( '<', 'filename' );
     
     my $file = Rex::FS::File->new(fh => $fh);

Create a `Rex::FS::File` object with a filename

     # open a local file in read mode
     my $file = Rex::FS::File->new(
       filename => 'filename',
       mode     => 'r', # or '<'
       type     => 'Local',
     );
     
     # or shorter
     my $file = Rex::FS::File->new( filename => 'filename' );
     
     # open a local file in write mode
     my $file = Rex::FS::File->new(
       filename => 'filename',
       mode     => 'w', # or '>'
     );

Allowed modes:

     <  read
     r  read
     >  write
     w  write
     >> append
     a  append

For allowed `types` see documentation of <span>Rex::Interface::File</span>.

## write($buf)

Write $buf into the filehandle.

     $file->write("Hello World");

## seek($offset)

Seek to the file position $offset.

Set the file pointer to the 5th byte.

     $file->seek(5);

## read($len)

Read $len bytes out of the filehandle.

     my $content = $file->read(1024);

## read\_all

Read everything out of the filehandle.

     my $content = $file->read_all;

## close

Close the file.

     $file->close;
