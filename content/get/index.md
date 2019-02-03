## Apple Mac OS X

To install Rex on Mac OSX you have to install libssh2 first. You can do this with MacPorts or with Homebrew.
We recommend using MacPorts. First you need to install XCode. After you've installed it you'll find a package for your system here.
If you're using homebrew we recommend to install a custom perl with Perlbrew.

Installation instructions for MacPorts:

    $ sudo port install libssh2 perl5
    $ curl -L https://get.rexify.org | perl - --sudo -n Rex

## Microsoft Windows

Tested with Windows Vista and Windows 7 (64bit) and Strawberry Perl 5.x
Start a CMD window and type:

    $ cpanm Rex

If you want to use Rex/Boxes you need to add the installation path of VirtualBox to your PATH environment variable. The default installation path is C:\\Program Files\\Oracle\\VirtualBox. If you need instructions how to do that you can read this article on ComputerHope.

From source

You can clone our repository from GitHub and install Rex from source. Development is done in the master branch, and we also tag each release there.

    $ git clone https://github.com/RexOps/Rex.git
    $ cd Rex
    $ cpanm Dist::Zilla
    $ dzil authordeps --missing | cpanm
    $ dzil listdeps --missing | cpanm
    $ dzil install

## CPAN

The following command will download and install the latest Rex release from CPAN.

    $ cpanm Rex

 

*All logos are registered trademarks of their respective companies and are not affiliated with and do not necessarily indicate that they either sponsor or endorse the services of rexify.org (and Rex).*

<span class="admin_snippet" data-pitahaya-block="block_id:bash_code">  </span>

<span class="admin_snippet" data-pitahaya-block="block_id:bash_code">  </span>

<span class="admin_snippet" data-pitahaya-block="block_id:bash_code">  </span>
