### For Xenial (16.04)

<span class="admin_snippet" data-pitahaya-block="block_id:bash_code"></span>

    $ apt-get install apt-transport-https
    $ echo 'deb https://rex.linux-files.org/ubuntu/ xenial rex' >> /etc/apt/sources.list
    $ wget -O - https://rex.linux-files.org/DPKG-GPG-KEY-REXIFY-REPO | apt-key add -
    $ apt-get update
    $ apt-get install rex

### For Trusty (14.04)

<span class="admin_snippet" data-pitahaya-block="block_id:bash_code"></span>

    $ apt-get install apt-transport-https
    $ echo 'deb https://rex.linux-files.org/ubuntu/ trusty rex' >> /etc/apt/sources.list
    $ wget -O - https://rex.linux-files.org/DPKG-GPG-KEY-REXIFY-REPO | apt-key add -
    $ apt-get update
    $ apt-get install rex

### For Precise (12.04)

<span class="admin_snippet" data-pitahaya-block="block_id:bash_code"></span>

    $ apt-get install apt-transport-https
    $ echo 'deb https://rex.linux-files.org/ubuntu/ precise rex' >> /etc/apt/sources.list
    $ wget -O - https://rex.linux-files.org/DPKG-GPG-KEY-REXIFY-REPO | apt-key add -
    $ apt-get update
    $ apt-get install rex


