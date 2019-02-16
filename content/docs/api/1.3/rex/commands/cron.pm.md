---
title: Cron.pm
---

-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [SYNOPSIS](#SYNOPSIS)
-   [EXPORTED FUNCTIONS](#EXPORTED-FUNCTIONS)
    -   [cron\_entry($name, %option)](#cron_entry-name-option-)
    -   [cron($action =&gt; $user, ...)](#cron-action-user-...-)

# NAME

Rex::Commands::Cron - Simple Cron Management

# DESCRIPTION

With this Module you can manage your cronjobs.

# SYNOPSIS

     use Rex::Commands::Cron;
     
     cron add => "root", {
            minute => '5',
            hour  => '*',
            day_of_month   => '*',
            month => '*',
            day_of_week => '*',
            command => '/path/to/your/cronjob',
          };
     
     cron list => "root";
     
     cron delete => "root", 3;

# EXPORTED FUNCTIONS

## cron\_entry($name, %option)

Manage cron entries.

     cron_entry "reload-httpd",
       ensure       => "present",
       command      => "/etc/init.d/httpd restart",
       minute       => "1,5",
       hour         => "11,23",
       month        => "1,5",
       day_of_week  => "1,3",
       day_of_month => "1,3,5",
       user         => "root",
       on_change    => sub { say "cron added"; };
     
     # remove an entry
     cron_entry "reload-httpd",
       ensure       => "absent",
       command      => "/etc/init.d/httpd restart",
       minute       => "1,5",
       hour         => "11,23",
       month        => "1,5",
       day_of_week  => "1,3",
       day_of_month => "1,3,5",
       user         => "root",
       on_change    => sub { say "cron removed."; };

## cron($action =&gt; $user, ...)

With this function you can manage cronjobs.

List cronjobs.

     use Rex::Commands::Cron;
     use Data::Dumper;
     
     task "listcron", "server1", sub {
       my @crons = cron list => "root";
       print Dumper(\@crons);
     };

Add a cronjob.

This example will add a cronjob running on minute 1, 5, 19 and 40. Every hour and every day.

     use Rex::Commands::Cron;
     use Data::Dumper;
     
     task "addcron", "server1", sub {
        cron add => "root", {
          minute => "1,5,19,40",
          command => '/path/to/your/cronjob',
        };
     };

This example will add a cronjob running on the 1st, 3rd and 5th day of January and May, but only when it's a Monday or Wednesday. On those days, the job will run when the hour is 11 or 23, and the minute is 1 or 5 (in other words at 11:01, 11:05, 23:01 and 23:05).

     task "addcron", "server1", sub {
        cron add => "root", {
          minute => "1,5",
          hour  => "11,23",
          month  => "1,5",
          day_of_week => "1,3",
          day_of_month => "1,3,5",
          command => '/path/to/your/cronjob',
        };
     };

Delete a cronjob.

This example will delete the 4th cronjob. Counting starts with zero (0).

     task "delcron", "server1", sub {
        cron delete => "root", 3;
     };

Managing Environment Variables inside cron.

     task "mycron", "server1", sub {
        cron env => user => add => {
          MYVAR => "foo",
        };
     
        cron env => user => delete => $index;
        cron env => user => delete => 1;
     
        cron env => user => "list";
     };
