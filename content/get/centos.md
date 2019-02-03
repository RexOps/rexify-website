## CentOS 7

<span class="admin_snippet" data-pitahaya-block="block_id:bash_code"></span>

    $ rpm --import https://rex.linux-files.org/RPM-GPG-KEY-REXIFY-REPO.CENTOS6

    $ cat >/etc/yum.repos.d/rex.repo <<EOF
    [rex]
    name=Fedora \$releasever - \$basearch - Rex Repository
    baseurl=https://rex.linux-files.org/CentOS/\$releasever/rex/\$basearch/
    enabled=1
    EOF

    $ yum install rex

## <span class="admin_snippet" data-pitahaya-block="block_id:bash_code"></span>

CentOS 6

<span class="admin_snippet" data-pitahaya-block="block_id:bash_code"></span>

<span class="admin_snippet" data-pitahaya-block="block_id:bash_code"></span>

    $ rpm --import https://rex.linux-files.org/RPM-GPG-KEY-REXIFY-REPO.CENTOS6

    $ cat >/etc/yum.repos.d/rex.repo <<EOF
    [rex]
    name=Fedora \$releasever - \$basearch - Rex Repository
    baseurl=https://rex.linux-files.org/CentOS/\$releasever/rex/\$basearch/
    enabled=1
    EOF

    $ yum install rex

## <span class="admin_snippet" data-pitahaya-block="block_id:bash_code"></span>

CentOS 5

<span class="admin_snippet" data-pitahaya-block="block_id:bash_code"></span>

<span class="admin_snippet" data-pitahaya-block="block_id:bash_code"></span>

<span class="admin_snippet" data-pitahaya-block="block_id:bash_code"></span>

    $ rpm --import https://rex.linux-files.org/RPM-GPG-KEY-REXIFY-REPO.CENTOS5

    $ cat >/etc/yum.repos.d/rex.repo <<EOF
    [rex]
    name=Fedora \$releasever - \$basearch - Rex Repository
    baseurl=https://rex.linux-files.org/CentOS/\$releasever/rex/\$basearch/
    enabled=1
    EOF

    $ yum install rex
