## For Jessie

<span class="admin_snippet" data-pitahaya-block="block_id:bash_code"></span>

    $ apt-get install apt-transport-https
    $ echo 'deb https://rex.linux-files.org/debian/ jessie rex' >> /etc/apt/sources.list
    $     wget -O - https://rex.linux-files.org/DPKG-GPG-KEY-REXIFY-REPO | apt-key add -
    $ apt-get update
    $ apt-get install rex

## For Wheezy

<span class="admin_snippet" data-pitahaya-block="block_id:bash_code"></span>

    $ apt-get install apt-transport-https
    $ echo 'deb https://rex.linux-files.org/debian/ wheezy rex' >> /etc/apt/sources.list
    $ wget -O - https://rex.linux-files.org/DPKG-GPG-KEY-REXIFY-REPO | apt-key add -
    $ apt-get update
    $ apt-get install rex

## <span class="admin_snippet" data-pitahaya-block="block_id:bash_code"></span>

For Squeeze

<span class="admin_snippet" data-pitahaya-block="block_id:bash_code"></span>

<span class="admin_snippet" data-pitahaya-block="block_id:bash_code"></span>

    $ apt-get install apt-transport-https
    $ echo 'deb https://rex.linux-files.org/debian/ squeeze rex' >> /etc/apt/sources.list
    $ wget -O - https://rex.linux-files.org/DPKG-GPG-KEY-REXIFY-REPO | apt-key add -
    $ apt-get update
    $ apt-get install rex