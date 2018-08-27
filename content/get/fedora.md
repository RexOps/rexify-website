Fedora 20+
----------

<span class="admin_snippet" data-pitahaya-block="block_id:bash_code"></span>

    $ rpm --import https://rex.linux-files.org/RPM-GPG-KEY-REXIFY-REPO

    $ cat >/etc/yum.repos.d/rex.repo <<EOF
    [rex]
    name=Fedora \$releasever - \$basearch - Rex Repository
    baseurl=https://rex.linux-files.org/Fedora/\$releasever/rex/\$basearch/
    enabled=1
    EOF

    $ yum install rex
