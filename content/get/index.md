---
title: Get Rex
links:
  stylesheet:
    - href: /public/css/skin/rexify.org/get-rex-vertical.css
---

You can install Rex with a simple one-liner:

    $ curl -L https://get.rexify.org | perl - --sudo -n Rex

BSD and Linux

Rex is also available as a package for many major distributions. Just choose your distribution and follow the steps shown.

<div>
<div class="tabs">

  <div class="tab" id="ubuntu">
     <input type="radio" id="tab-ubuntu" name="tabs" checked>
     <label for="tab-ubuntu"><img src="/public/images/skin/rexify.org/ubuntu.png"></label>

     <div class="content">
<h2>For Xenial (16.04)</h2>

<pre><code class="bash">    $ apt-get install apt-transport-https
    $ echo 'deb https://rex.linux-files.org/ubuntu/ xenial rex' >> /etc/apt/sources.list.d/rex.list
    $ wget -O - https://rex.linux-files.org/DPKG-GPG-KEY-REXIFY-REPO | apt-key add -
    $ apt-get update
    $ apt-get install rex
</code></pre>

<h2>For Trusty (14.04)</h2>

<pre><code class="bash">    $ apt-get install apt-transport-https
    $ echo 'deb https://rex.linux-files.org/ubuntu/ trusty rex' &lt;&lt; /etc/apt/sources.list.d/rex.list
    $ wget -O - https://rex.linux-files.org/DPKG-GPG-KEY-REXIFY-REPO | apt-key add -
    $ apt-get update
    $ apt-get install rex
</code></pre>

<h2>For Precise (12.04)</h2>

<pre><code class="bash">    $ apt-get install apt-transport-https
    $ echo 'deb https://rex.linux-files.org/ubuntu/ precise rex' &lt;&lt; /etc/apt/sources.list.d/rex.list
    $ wget -O - https://rex.linux-files.org/DPKG-GPG-KEY-REXIFY-REPO | apt-key add -
    $ apt-get update
    $ apt-get install rex
</code></pre>

   </div>
 </div>

  <div class="tab" id="debian">
     <input type="radio" id="tab-debian" name="tabs" >
     <label for="tab-debian"><img src="/public/images/skin/rexify.org/debian.png"></label>

     <div class="content">

<h2>For Jessie</h2>

<pre><code class="bash">    $ apt-get install apt-transport-https
    $ echo 'deb https://rex.linux-files.org/debian/ jessie rex' &lt;&lt; /etc/apt/sources.list.d/rex.list
    $ wget -O - https://rex.linux-files.org/DPKG-GPG-KEY-REXIFY-REPO | apt-key add -
    $ apt-get update
    $ apt-get install rex
</code></pre>

<h2>For Wheezy</h2>

<pre><code class="bash">    $ apt-get install apt-transport-https
    $ echo 'deb https://rex.linux-files.org/debian/ wheezy rex' &lt;&lt; /etc/apt/sources.list.d/rex.list
    $ wget -O - https://rex.linux-files.org/DPKG-GPG-KEY-REXIFY-REPO | apt-key add -
    $ apt-get update
    $ apt-get install rex
</code></pre>

<h2>For Squeeze</h2>

<pre><code class="bash">    $ apt-get install apt-transport-https
    $ echo 'deb https://rex.linux-files.org/debian/ squeeze rex' &lt;&lt; /etc/apt/sources.list.d/rex.list
    $ wget -O - https://rex.linux-files.org/DPKG-GPG-KEY-REXIFY-REPO | apt-key add -
    $ apt-get update
    $ apt-get install rex
</code></pre>

</div>
</div>

  <div class="tab" id="gentoo">
     <input type="radio" id="tab-gentoo" name="tabs" >
     <label for="tab-gentoo"><img src="/public/images/skin/rexify.org/gentoo.png"></label>

     <div class="content">

<h2>Installation with emerge</h2>

Thanks to Bonsaikitten Rex is now available in the official Gentoo Portage Repository.

<pre><code class="bash">    $ emerge -av app-admin/rex
</code></pre>

</div>
</div>

  <div class="tab" id="centos">
     <input type="radio" id="tab-centos" name="tabs" >
     <label for="tab-centos"><img src="/public/images/skin/rexify.org/centos.png"></label>

     <div class="content">

<h2>CentOS 7</h2>

<pre><code class="bash">    $ rpm --import https://rex.linux-files.org/RPM-GPG-KEY-REXIFY-REPO.CENTOS6

    $ cat &lt;/etc/yum.repos.d/rex.repo &gt;&gt;EOF
    [rex]
    name=CentOS \$releasever - \$basearch - Rex Repository
    baseurl=https://rex.linux-files.org/CentOS/\$releasever/rex/\$basearch/
    enabled=1
    EOF

    $ yum install rex
</code></pre>

<h2>CentOS 6</h2>

<pre><code class="bash">    $ rpm --import https://rex.linux-files.org/RPM-GPG-KEY-REXIFY-REPO.CENTOS6

    $ cat &lt;/etc/yum.repos.d/rex.repo &gt;&gt;EOF
    [rex]
    name=CentOS \$releasever - \$basearch - Rex Repository
    baseurl=https://rex.linux-files.org/CentOS/\$releasever/rex/\$basearch/
    enabled=1
    EOF

    $ yum install rex
</code></pre>

<h2>CentOS 5</h2>

<pre><code class="bash">    $ rpm --import https://rex.linux-files.org/RPM-GPG-KEY-REXIFY-REPO.CENTOS5

    $ cat &lt;/etc/yum.repos.d/rex.repo &gt;&gt;EOF
    [rex]
    name=CentOS \$releasever - \$basearch - Rex Repository
    baseurl=https://rex.linux-files.org/CentOS/\$releasever/rex/\$basearch/
    enabled=1
    EOF

    $ yum install rex
</code></pre>

</div>
</div>

  <div class="tab" id="suse">
     <input type="radio" id="tab-suse" name="tabs" >
     <label for="tab-suse"><img src="/public/images/skin/rexify.org/suse.png"></label>

     <div class="content">
<h2>For 13.1</h2>

<pre><code class="bash">    $ rpm --import https://rex.linux-files.org/RPM-GPG-KEY-REXIFY-REPO
    $ zypper addrepo -t rpm-md -f -n rex https://rex.linux-files.org/OpenSuSE/13.1/rex/x86_64/ rex
    $ zypper install rex
</code></pre>

<h2>For 13.2</h2>

<pre><code class="bash">    $ rpm --import https://rex.linux-files.org/RPM-GPG-KEY-REXIFY-REPO
    $ zypper addrepo -t rpm-md -f -n rex https://rex.linux-files.org/OpenSuSE/13.2/rex/x86_64/ rex
    $ zypper install rex
</code></pre>
</div>
</div>

  <div class="tab" id="fedora">
     <input type="radio" id="tab-fedora" name="tabs" >
     <label for="tab-fedora"><img src="/public/images/skin/rexify.org/fedora.png"></label>

     <div class="content">
<h2>Fedora 20+</h2>

<pre><code class="bash">    $ rpm --import https://rex.linux-files.org/RPM-GPG-KEY-REXIFY-REPO

    $ cat &lt;/etc/yum.repos.d/rex.repo &gt;&gt;EOF
    [rex]
    name=Fedora \$releasever - \$basearch - Rex Repository
    baseurl=https://rex.linux-files.org/Fedora/\$releasever/rex/\$basearch/
    enabled=1
    EOF

    $ yum install rex
</code></pre>

</div>
</div>

  <div class="tab" id="freebsd">
     <input type="radio" id="tab-freebsd" name="tabs" >
     <label for="tab-freebsd"><img src="/public/images/skin/rexify.org/freebsd.png"></label>

     <div class="content">
<h2>Installation with ports</h2>

Thanks to Sam Cassiba Rex is now available in the official FreeBSD Ports collection.

<pre><code class="bash">    $ cd /usr/ports/sysutils/p5-Rex
    $ make install clean
</code></pre>

<h2>Installation with pkg</h2>

<pre><code class="bash">    $ pkg install p5-Rex
</code></pre>

</div>
</div>

</div>
</div>
<div style="clear:both"></div>

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
