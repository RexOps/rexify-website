---
title: DBI.pm
---

-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [SYNOPSIS](#SYNOPSIS)
-   [EXPORTED FUNCTIONS](#EXPORTED-FUNCTIONS)
    -   [groups\_dbi($dsn, $user, $password, $sql)](#groups_dbi-dsn-user-password-sql-)
    -   [Example: groups\_dbi( 'DBI:mysql:rex;host=db01', user =&gt; 'username', password =&gt; 'password', sql =&gt; "SELECT \* FROM HOST", create\_all\_group =&gt; TRUE);](#Example:-groups_dbi-DBI:mysql:rex-host-db01-user-username-password-password-sql-SELECT-FROM-HOST-create_all_group-TRUE-)
    -   [Database sample for MySQL](#Database-sample-for-MySQL)
    -   [Data sample for MySQL](#Data-sample-for-MySQL)

# NAME

Rex::Group::Lookup::DBI - read hostnames and groups from a DBI source

# DESCRIPTION

With this module you can define hostgroups out of an DBI source.

# SYNOPSIS

     use Rex::Group::Lookup::DBI;
     groups_dbi "dsn", "user", "password", "SQL request";

# EXPORTED FUNCTIONS

## groups\_dbi($dsn, $user, $password, $sql)

     With this function you can read groups from DBI source.

## Example: groups\_dbi( 'DBI:mysql:rex;host=db01', user =&gt; 'username', password =&gt; 'password', sql =&gt; "SELECT \* FROM HOST", create\_all\_group =&gt; TRUE);

## Database sample for MySQL

     CREATE TABLE IF NOT EXISTS `HOST` (
       `ID` int(11) NOT NULL,
       `GROUP` varchar(255) DEFAULT NULL,
       `HOST` varchar(255) NOT NULL,
       PRIMARY KEY (`ID`)
     );

## Data sample for MySQL

     INSERT INTO `HOST` (`ID`, `GROUP`, `HOST`) VALUES
       (1, 'db', 'db01'),
       (2, 'db', 'db02'),
       (3, 'was', 'was01'),
       (4, 'was', 'was02');
