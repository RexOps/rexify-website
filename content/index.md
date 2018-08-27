<div style="float: left;">
<div class="row-fluid">
<div class="span4">
<h2>Why use Rex?</h2>
<p>If you have to do a task more than once, automate it!</p>
<p>Don&lsquo;t forget an installation step anymore. Automation reduces the risk of failure and let you do your real work.</p>
</div>
<div class="span4">
<h2>Advantages</h2>
<ul class="no-list">
<li>Uses ssh, no agent required</li>
<li>Seamless integration, no conflicts</li>
<li>Easy to use and to extend</li>
<li>Easy to learn, it&lsquo;s just plain Perl</li>
</ul>
</div>
<div class="span4">
<h2>Open source</h2>
<p>We believe in the idea of open source. So Rex, and all its parts are released under the Apache 2.0 license.</p>
<p>You&lsquo;re invited to join the community to make Rex better and better.</p>
</div>
</div>

<div class="row-fluid">
<div class="span4">&nbsp;</div>
<div class="span4">
<p><a class="btn" href="/docs/guides/just_enough_perl_for_rex.html">Just enough Perl for Rex &raquo;</a></p>
</div>
<div class="span4">
<p><a class="btn" href="/care/help__r__ex.html">View details &raquo;</a></p>
</div>
</div>
</div>

## Uptime?

This command line example will execute <code>uptime</code> on all the given hosts (<code>frontend01</code>, <code>frontend02</code>, ...)

<pre><code class="bash">$ rex -H "frontend[01..15]" -e "say run 'uptime'"</code></pre>

The same, but with a Rexfile

<pre><code class="perl">use Rex -feature =&gt; ['1.0'];
desc "Get Uptime";
task "uptime", sub {
  say run "uptime";
};</code></pre>

Now you can run your task with this command:

<pre><code class="bash">$ rex -H "frontend[01..15] middleware[01..05] db[01..04]" -u ssh-user -p ssh-password uptime</code></pre>

## Keep Your Configuration In Sync

This example will install the Apache webserver on 5 machines and keep their configuration in sync. If the deployed configuration file changes, it will automatically reload the service.

If this task gets executed against a "virgin" host (where no Apache is installed yet), it will first install it.

<pre><code class="perl">use Rex -feature =&gt; ['1.0'];

user "root";
group frontend =&gt; "frontend[01..05]";

desc "Prepare Frontend Server";
task "prepare", group =&gt; "frontend", sub {
  pkg "apache2",
    ensure =&gt; "latest";

  service "apache2",
    ensure =&gt; "started";
};

desc "Keep Configuration in sync";
task "configure", group =&gt; "frontend", sub {
  prepare();

  file "/etc/apache2/apache2.conf",
    source    =&gt; "files/etc/apache2/apache2.conf",
    on_change =&gt; sub { service apache2 =&gt; "reload"; };
  };</code></pre>

## Running under sudo?

You can also run everything with sudo. Just define the sudo password and activate sudo.

<pre><code class="perl">use Rex -feature =&gt; ['1.0'];

user "ubuntu";
group frontend =&gt; "frontend[01..05]";
sudo TRUE;
sudo_password "mysudopw";

desc "Prepare Frontend Server";
task "prepare", group =&gt; "frontend", sub {
  pkg "apache2",
    ensure =&gt; "latest";

  service "apache2",
    ensure =&gt; "started";
};

desc "Keep Configuration in sync";
task "configure", group =&gt; "frontend", sub {
  prepare();

  file "/etc/apache2/apache2.conf",
    source    =&gt; "files/etc/apache2/apache2.conf",
    on_change =&gt; sub { service apache2 =&gt; "reload"; };
};</code></pre>

