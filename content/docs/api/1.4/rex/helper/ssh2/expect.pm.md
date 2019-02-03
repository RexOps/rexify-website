-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [DEPENDENCIES](#DEPENDENCIES)
-   [SYNOPSIS](#SYNOPSIS)
-   [CLASS METHODS](#CLASS-METHODS)
    -   [new($ssh2)](#new-ssh2-)
    -   [log\_stdout(0|1)](#log_stdout-0-1-)
    -   [log\_file($file)](#log_file-file-)
    -   [spawn($command, @parameters)](#spawn-command-parameters-)
    -   [soft\_close()](#soft_close-)
    -   [hard\_close();](#hard_close-)
    -   [expect($timeout, @match\_patters)](#expect-timeout-match_patters-)
    -   [send($string)](#send-string-)

# NAME

Rex::Helper::SSH2::Expect - An Expect like module for Net::SSH2

# DESCRIPTION

This is a module to have expect like features for Net::SSH2. This is the first version of this module. Please report bugs at GitHub <https://github.com/krimdomu/net-ssh2-expect>

# DEPENDENCIES

-   <span>Net::SSH2</span>

# SYNOPSIS

     use Rex::Helper::SSH2::Expect;
         
     my $exp = Rex::Helper::SSH2::Expect->new($ssh2);
     $exp->spawn("passwd");
     $exp->expect($timeout, [
                      qr/Enter new UNIX password:/ => sub {
                                              my ($exp, $line) = @_;
                                              $exp->send($new_password);
                                            }
                    ],
                    [
                      qr/Retype new UNIX password:/ => sub {
                                              my ($exp, $line) = @_;
                                              $exp->send($new_password);
                                            }
                    ],
                    [
                      qr/passwd: password updated successfully/ => sub {
                                                      my ($exp, $line) = @_;
                                                      $exp->hard_close;
                                                    }
                    ]);

# CLASS METHODS

## new($ssh2)

Constructor: You need to parse an connected Net::SSH2 Object.

## log\_stdout(0|1)

Log on STDOUT.

## log\_file($file)

Log everything to a file. $file can be a filename, a filehandle or a subRef.

## spawn($command, @parameters)

Spawn $command with @parameters as parameters.

## soft\_close()

Currently only an alias to hard\_close();

## hard\_close();

Stops the execution of the process.

## expect($timeout, @match\_patters)

This method controls the execution of your process.

## send($string)

Send a string to the running command.
