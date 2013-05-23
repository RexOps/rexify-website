#!/usr/bin/env perl -w

use strict;
use warnings;
use utf8;

use DateTime;

use Cwd qw(getcwd);
use Mojolicious::Lite;
use Mojo::UserAgent;
use Data::Dumper;

plugin 'RenderFile';

get '/' => sub {
   my ($self) = @_;
   $self->stash("no_side_bar", 0);
   $self->render("index", root => 1, cat => "", no_disqus => 1);
};

# special code to handle ,,rexify --search'' requests
get '/get/recipes' => sub {
   my ($self) = @_;
   my $ua = Mojo::UserAgent->new;
   $self->render_text($ua->get("https://raw.github.com/krimdomu/rex-recipes/master/recipes.yml")->res->body);
};

# special code to handle ,,rexify --use'' requests
get '/get/mod/*mod' => sub {
   my ($self) = @_;

   my $cur_dir = getcwd;

   my $mod = $self->param("mod");
   my $mod_name = $mod . ".pm";

   if( ! -d "/tmp/scratch") {
      mkdir "/tmp/scratch";
   }

   chdir("/tmp/scratch");

   my $u = get_random(32, 'a' .. 'z');  
   system("git clone git://github.com/krimdomu/rex-recipes.git $u >/dev/null 2>&1");
   chdir("$u");
   system("git checkout master");

   system("tar czf ../$u.tar.gz $mod $mod_name >/dev/null 2>&1");

   chdir($cur_dir);

   $self->render_file(filepath => "/tmp/scratch/$u.tar.gz");
};

get '/search' => sub {
   my ($self) = @_;

   my $term = $self->param("q");

   $term =~ s/(\w+)/$1*/g;

   my $ua = Mojo::UserAgent->new;
   my $tx = $ua->post_json("http://localhost:9200/_search?pretty=true", {
      query => {
         query_string => {
            query => $term,
         },
      },
      fields => [qw/fs title/],
      highlight => {
         fields => {
            file => {},
         },
      },
   });

   $self->stash("no_side_bar", 0);
   $self->stash("root", 0);
   $self->stash("no_disqus", 1);
   $self->stash("cat", "");


   if(my $json = $tx->res->json) {
      return $self->render("search", hits => $json->{hits});
   }
   else {
      return $self->render("search", hits => { total => 0, });
   }
};


get '/*file' => sub {
   my ($self) = @_;

   my $template = $self->param("file");

   my ($cat) = ($template =~ m/^([^\/]+)\//);
   $cat ||= "";
   $self->stash("cat", $cat);

   if($template eq "howtos/compatibility.html") {
      $self->stash("no_side_bar", 1);
   }
   else {
      $self->stash("no_side_bar", 0);
   }

   if(-f "public/$template") {
      return $self->render_file(filepath => "public/$template", no_disqus => 0, root => 0);
   }

   if(-d "templates/$template") {
      return $self->redirect_to("$template/index.html", root => 0);
   }

   if(-f "templates/$template.ep") {
      $template =~ s/\.html$//;
      $self->render($template, no_disqus => 0, root => 0);
   }
   else {
      $self->render('404', status => 404, no_disqus => 1, root => 0);
   }

};


app->start;

__DATA__

@@ search.html.ep

% layout 'default';
% title 'Search for ' . param('q');

% if( $hits->{total} == 0 ) {

<p>I'm sorry. Your query had no results!</p>

% } else {

% my @api_results     = grep { $_->{_index} eq "api" } @{ $hits->{hits} };
% my @webpage_results = grep { $_->{_index} eq "webpage" } @{ $hits->{hits} };

% if(@api_results) {
<h1>API</h1>
   <ul>
   % for my $r (@api_results) {
      <li>
         <p><a href="<%= $r->{fields}->{fs} %>"><%= $r->{fields}->{title} %></a></p>
         <div class="small-vspace"></div>
         <p><b>Found here:</b></p>
         % for my $h (@{ $r->{highlight}->{file} }) {
         <p class="highlight-search" style="margin-left: 0px"><%== $h %></p>
         % }
         <div class="small-vspace"></div>
      </li>
   % }
   </ul>
% }

% if(@webpage_results) {
<div class="vspace"></div>
<h1>Website</h1>
   <ul>
   % for my $r (@webpage_results) {
      <li>
         <a href="<%= $r->{fields}->{fs} %>"><%= $r->{fields}->{title} %></a>
         <div class="small-vspace"></div>
         <p><b>Found here:</b></p>
         % for my $h (@{ $r->{highlight}->{file} }) {
         <p class="highlight-search" style="margin-left: 0px"><%== $h %></p>
         % }
         <div class="small-vspace"></div>
      </li>
   % }
   </ul>
% }

% }

@@ 404.html.ep

% layout 'default';
% title '404 - File not found';

<h1>404 - I'm really sorry :(</h1>
<p>Hello. I'm a Webserver. And i'm there to serve files for you. But i'm really sorry :( I can't find the file you want to see.</p>

@@ index_head.html.ep

         <div id="head-div">
            <div class="head_container">
               <div class="slogan">
                  <h1>Automate Everything, Relax Anytime</h1>
                  <div class="slogan_list">
                     <ul>
                        <li>&gt; Integrates seamless in your running environment</li>
                        <li>&gt; Easy to use and extend</li>
                        <li>&gt; Easy to learn, it's just plain Perl</li>
                        <li>&gt; Apache 2.0 licensed</li>
                     </ul>
                  </div> <!-- slogan_list -->

                  <div class="source">
                     <pre><code class="perl">task prepare => sub {
   install "apache2";
   service apache2 => ensure => "started";
};</code></pre>
                  </div> <!-- source -->
                  <a class="headlink" href="/howtos/start.html">Read the Getting Started Guide</a>
               </div> <!-- slogan -->

            </div> <!-- head_container -->
         </div>



@@ navigation.html.ep

             <div class="nav_links">
               <ul>
                  <li <% if($cat eq "") { %>class="active" <% } %>><a href="/">Home</a></li>
                  <li <% if($cat eq "get") { %>class="active" <% } %>><a href="/get" title="Install Rex on your systems">Get Rex</a></li>
                  <li <% if($cat eq "contribute") { %>class="active" <% } %>><a href="/contribute" title="Help Rex to get even better">Contribute</a></li>
                  <li <% if($cat eq "howtos" || $cat eq "modules") { %>class="active" <% } %>><a href="/howtos" title="Examples, Howtos and Documentation">Docs</a></li>
                  <li <% if($cat eq "api") { %>class="active" <% } %>><a href="/api" title="The complete API documentation">API</a></li>
               </ul>
            </div>

@@ layouts/default.html.ep
<!DOCTYPE html 
     PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
     "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
   <head>
      <meta http-equiv="content-type" content="text/html; charset=utf-8" />
   
      <title><%= title %></title>

      <meta name="viewport" content="width=1024, initial-scale=0.5">

      <link href="http://yandex.st/highlightjs/7.3/styles/magula.min.css" rel="stylesheet"/>
      <link rel="stylesheet" href="/css/bootstrap.min.css?20130325" type="text/css" media="screen" charset="utf-8" />
      <link rel="stylesheet" href="/css/default.css?20130325" type="text/css" media="screen" charset="utf-8" />

      <meta name="description" content="(R)?ex - manage all your boxes from a central point - Datacenter Automation and Configuration Management" />
      <meta name="keywords" content="Systemadministration, Datacenter, Automation, Rex, Rexfiy, Rexfile, Example, Remote, Configuration, Management, Framework, SSH, Linux" />

      <style>
      % if($no_side_bar) {
         #content_container {
            margin-left: 5px;
         }

         #widgets {
            display: none;
         }
      % }
      </style>

   </head>
   <body>

      <div id="page">

      % if($root) {
         <div id="index-top-div" class="top_div">
            <h1>(R)?ex <small>Deployment &amp; Configuration Management</small></h1>
         </div>

         %= include 'index_head';
         <div class="nav_title">
            <span style="color: #7b4d29;">Y</span>our <span style="color: #7b4d29;">W</span>ay
         </div>

         <div id="index-nav-div">
            %= include 'navigation';
         </div>
      % } else {
         <div id="top-div" class="top_div">
            <h1>(R)?ex <small>Deployment &amp; Configuration Management</small></h1>
            <div id="nav-div">
               %= include 'navigation';
            </div>
         </div>
      % }

         <div id="widgets_container">
            <div id="widgets">
               <h2>Search</h2>
               <form action="/search" method="GET">
                  <input type="text" name="q" id="q" class="search_field" /><button class="btn">Go</button>
               </form>
               <h2>News</h2>

               <div class="news_widget">
                  <div class="news_date">2013-05-23</div>
                  <div class="news_content">Inovex <a href="http://www.inovex.de/news-events/news/">just announced</a> that they offer professional support for Rex.</div>
               </div>


               <div class="news_widget">
                  <div class="news_date">2013-04-01</div>
                  <div class="news_content">(R)?ex 0.41.0 released. This release brings a handfull of new functions that ease the use and bug fixes. See <a href="https://github.com/krimdomu/Rex/wiki/New0.41">ChangeLog</a> for more information.</div>
                  <div class="news_content">There is also a new guide on <a href="/howtos/using_templates.html">howto use modules and templates</a> online.</div>
               </div>

               <div class="news_widget">
                  <div class="news_date">2013-03-20</div>
                  <div class="news_content">
                     <img src="/img/init_mittelstand.png" style="float: left; height: 70px;" />
                     <p>We are proud to announce that Rex was voted under the Best Open Source solutions 2013 by <a href="http://www.imittelstand.de/">initiative mittelstand</a>. And we want to thank <a href="http://inovex.de">inovex</a> for the support to make this happen.</p>
                  </div>
               </div>

               <div class="news_widget">
                  <div class="news_date">2013-03-16</div>
                  <div class="news_content">Talk from the German Perl Workshop just got uploaded to slideshare (<a href="http://de.slideshare.net/jfried/von-test-nach-live-mit-rex">german</a>) and (<a href="http://de.slideshare.net/jfried/from-test-to-live-with-rex">english</a>).</div>
               </div>

               <div class="news_widget">
                  <div class="news_date">2013-02-24</div>
                  <div class="news_content">(R)?ex 0.40.0 released. This release added a common CMDB interface and a simple CMDB on YAML file basis. Read the <a href="https://github.com/krimdomu/Rex/wiki/New0.40">ChangeLog</a> for all changes.</div>
               </div>


               <h2>Conferences</h2>
               <img src="/img/osdc.png" style="float: left; width: 100px;" />
               <p><a href="http://www.osdc.de/">Open Source Data Center Conference</a></p>
               <p style="padding-top: 6px;">17 - 18 April 2013 in Nuremberg</p>
               <p>OSDC is about simplifying complex IT infrastructures with Open Source. A rare opportunity to meet with Open Source professionals and insiders, gather and share information over 2 days of presentations, hands-on workshops and social networking.</p>

               <img src="/img/linuxtag.jpg" style="float: left; width: 100px" />
               <p>We are proud to anounce that Rex will have a booth on the <a href="http://linuxtag.de/">LinuxTag</a>. The LinuxTag will take place in Berlin from 22. - 25. May. LinuxTag is the most popuplar and important conference in the Linux and Open Source scene in Europe.</p>
               <p>Come and join us, we will do live demostrations with a custom build portable mini datacenter.</p><p>If you want to help us for a day or two don't hesitate to contact <a href="mailto:jfried@rexify.org">@jfried83</a>.</p>

               <h2>Need Help?</h2>
               <p>Rex is a pure Open Source project. So you can find community support in the following places.</p>
               <ul>
                  <li>IRC: #rex on freenode</li>
                  <li>Groups: <a href="https://groups.google.com/group/rex-users/">rex-users</a></li>
                  <li>Issues: <a href="https://github.com/Krimdomu/Rex/issues">on Github</a></li>
                  <li>Feature: You miss a <a href="/feature.html">feature</a>?</li>
                  <li>Professional Support: <a href="http://www.inovex.de/news-events/news/">by inovex</a></li>
               </ul>
            </div>
         </div> <!-- widgets -->

         <div id="content_container">
            <div id="content">
               <%= content %>

 % if( ! $no_disqus) {

    <div id="disqus_thread" style="margin-top: 45px;"></div>
    <script type="text/javascript">
        /* * * CONFIGURATION VARIABLES: EDIT BEFORE PASTING INTO YOUR WEBPAGE * * */
        var disqus_shortname = 'rexify'; // required: replace example with your forum shortname

        /* * * DON'T EDIT BELOW THIS LINE * * */
        (function() {
            var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
            dsq.src = 'http://' + disqus_shortname + '.disqus.com/embed.js';
            (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
        })();
    </script>
    <noscript>Please enable JavaScript to view the <a href="http://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>
    <a href="http://disqus.com" class="dsq-brlink">comments powered by <span class="logo-disqus">Disqus</span></a>
    
    % }

            </div>
         </div> <!-- content -->

      </div> <!-- page -->
      

     <a href="http://github.com/Krimdomu/Rex"><img style="position: absolute; top: 0; right: 0; border: 0;" src="https://s3.amazonaws.com/github/ribbons/forkme_right_orange_ff7600.png" alt="Fork me on GitHub" /></a>



   <script type="text/javascript" charset="utf-8" src="/js/jquery.js"></script>
   <script type="text/javascript" charset="utf-8" src="/js/bootstrap.min.js"></script>

<!-- Piwik --> 
<script type="text/javascript">
var pkBaseURL = (("https:" == document.location.protocol) ? "https://rexify.org/stats/" : "http://rexify.org/stats/");
document.write(unescape("%3Cscript src='" + pkBaseURL + "piwik.js' type='text/javascript'%3E%3C/script%3E"));
</script><script type="text/javascript">
try {
var piwikTracker = Piwik.getTracker(pkBaseURL + "piwik.php", 1);
piwikTracker.trackPageView();
piwikTracker.enableLinkTracking();
} catch( err ) {}
</script><noscript><p><img src="http://rexify.org/stats/piwik.php?idsite=1" style="border:0" alt="" /></p></noscript>
<!-- End Piwik Tracking Code -->


<script src="http://yandex.st/highlightjs/7.3/highlight.min.js"></script>
<script>
  hljs.tabReplace = '    ';
  hljs.initHighlightingOnLoad();
  $("#q").focus();
</script>


   </body>

</html>

