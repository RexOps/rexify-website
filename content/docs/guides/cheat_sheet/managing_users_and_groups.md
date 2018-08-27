Manage local user database.

### account($user\_name, %options)

Manage user accounts.

#### Options

-   ensure - Defines the state of the account. Valid parameters are present, absent.
-   uid - The user id.
-   groups - The groups the user should be member of. The first group is the primary.
-   home - The home directory.
-   expire - Date when the account will expire. Format: YYYY-MM-DD
-   password - Cleartext password for the user.
-   crypt\_password - Crypted password for the user. Available on Linux, OpenBSD and NetBSD.
-   system - Create a system user.
-   create\_home - If the home directory should be created. Valid parameters are TRUE, FALSE.
-   ssh\_key - Add ssh key to authorized\_keys.
-   comment

<!-- -->

    account "krimdomu",
       ensure         => "present",  # default
       uid            => 509,
       home           => '/home/krimdomu',
       comment        => 'User Account',
       expire         => '2011-05-30',
       groups         => [ 'users', 'wheel' ],
       password       => 'blahblah',
       create_home    => TRUE,
       ssh_key        => "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQChUw...";

### group($group\_name, %options)

Manage groups.

#### Options

-   ensure - Defines the state of the group. Valid parameters are present, absent.
-   gid - The group id.
-   system - Create a system group.

<!-- -->

    group "users",
      ensure => "present";

 
