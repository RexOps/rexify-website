---
title: XML.pm
---

-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [SYNOPSIS](#SYNOPSIS)
-   [EXPORTED FUNCTIONS](#EXPORTED-FUNCTIONS)
    -   [groups\_xml($file)](#groups_xml-file-)
    -   [$schema\_file](#schema_file)

# NAME

Rex::Group::Lookup::XML - read hostnames and groups from a XML file

# DESCRIPTION

With this module you can define hostgroups out of an xml file.

# SYNOPSIS

     use Rex::Group::Lookup::XML;
     groups_xml "file.xml";

# EXPORTED FUNCTIONS

## groups\_xml($file)

With this function you can read groups from xml files.

File Example:

&lt;configuration&gt; &lt;group name="database"&gt; &lt;server name="machine01" user="root" password="foob4r" sudo="true" hdd="300" loc="/opt" /&gt; &lt;/group&gt; &lt;group name="application"&gt; &lt;server name="machine01" user="root" password="foob4r" sudo="true" hdd="50" loc="/export" /&gt; &lt;server name="machine02" user="root" password="foob5r" sudo="true"/&gt; &lt;/group&gt; &lt;group name="profiler"&gt; &lt;server name="machine03" user="root" password="blue123"/&gt; &lt;/group&gt; &lt;/configuration&gt;

     C<groups_xml($file);>
     
     The XML file is validated against the following DTD schema:
     
     

## $schema\_file

A global that defines the XSD schema for which the XML is check against.
