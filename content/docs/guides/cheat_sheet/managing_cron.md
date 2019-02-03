### Manage cron jobs.

cron\_entry($entry\_name, %options)

#### Options

-   ensure - Defines the state of the cron entry. Valid parameters are present, absent.
-   command - The command to run.
-   minute - The minute when to run the job.
-   hour - The hour when to run the job.
-   month - The month when to run the job.
-   day\_of\_week
-   day\_of\_month
-   user - The user for the cron job.
-   on\_change - A callback function that gets called when the cron entry state changed.

<!-- -->

    cron_entry "run-rkhunter",
      command => "rkhunter --cronjob",
      minute  => 5,
      hour    => 1;

 
