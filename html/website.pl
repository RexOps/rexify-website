#!/usr/bin/env perl -w

use strict;
use warnings;
use utf8;

use DateTime;
use IO::All;

use Cwd qw(getcwd);
use Mojolicious::Lite;
use Mojo::UserAgent;
use Data::Dumper;

plugin 'RenderFile';

sub get_news {
  my @content = eval { local (@ARGV) = ("news.txt"); <>; };
  chomp @content;

  my @ret;
  for my $line (@content) {
    my ( $date, $text ) = split /,/, $line, 2;
    push @ret, { date => $date, text => $text };
  }

  return @ret;
}

get '/' => sub {
  my ($self) = @_;
  $self->stash( "no_side_bar", 0 );
  $self->stash( "news", [get_news] );
  $self->render( "index", root => 1, cat => "", no_disqus => 1 );
};

# special code to handle ,,rexify --search'' requests
get '/get/recipes' => sub {
  my ($self) = @_;
  my $ua = Mojo::UserAgent->new;
  $self->render_text(
    $ua->get("https://raw.github.com/RexOps/rex-recipes/master/recipes.yml")
      ->res->body );
};

# special code to handle ,,rexify --use'' requests
get '/get/mod/*mod' => sub {
  my ($self) = @_;

  my $cur_dir = getcwd;

  my $mod      = $self->param("mod");
  my $mod_name = $mod . ".pm";

  if ( !-d "/tmp/scratch" ) {
    mkdir "/tmp/scratch";
  }

  chdir("/tmp/scratch");

  my $u = get_random( 32, 'a' .. 'z' );
  system(
    "git clone git://github.com/RexOps/rex-recipes.git $u >/dev/null 2>&1");
  chdir("$u");
  system("git checkout master");

  system("tar czf ../$u.tar.gz $mod $mod_name >/dev/null 2>&1");

  chdir($cur_dir);

  $self->render_file( filepath => "/tmp/scratch/$u.tar.gz" );
};

get '/search' => sub {
  my ($self) = @_;

  my $term = $self->param("q");

  $term =~ s/(\w+)/$1*/g;

  my $ua = Mojo::UserAgent->new;
  my $tx = $ua->post(
    "http://localhost:9200/_search?pretty=true",
    json => {
      query => {
        query_string => {
          query => $term,
        },
      },
      fields    => [qw/fs title/],
      highlight => {
        fields => {
          file => {},
        },
      },
    }
  );

  $self->stash( "no_side_bar", 0 );
  $self->stash( "root",        0 );
  $self->stash( "no_disqus",   1 );
  $self->stash( "cat",         "" );
  $self->stash( "news", [get_news] );

  if ( my $json = $tx->res->json ) {
    return $self->render( "search", hits => $json->{hits} );
  }
  else {
    return $self->render( "search", hits => { total => 0, } );
  }
};

get '/*file' => sub {
  my ($self) = @_;

  my $template = $self->param("file");

  $self->stash( "news", [get_news] );

  my ($cat) = ( $template =~ m/^([^\/]+)\// );
  $cat ||= "";
  $self->stash( "cat", $cat );

  if ( $template eq "howtos/compatibility.html" ) {
    $self->stash( "no_side_bar", 1 );
  }
  else {
    $self->stash( "no_side_bar", 0 );
  }

  if ( -f "public/$template" ) {
    return $self->render_file(
      filepath  => "public/$template",
      no_disqus => 0,
      root      => 0
    );
  }

  if ( -d "templates/$template" ) {
    return $self->redirect_to( "$template/index.html", root => 0 );
  }

  if ( -f "templates/$template.ep" ) {
    $template =~ s/\.html$//;
    $self->render( $template, no_disqus => 0, root => 0 );
  }
  else {
    $self->render( '404', status => 404, no_disqus => 1, root => 0 );
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
                  <li <% if($cat eq "contribute") { %>class="active" <% } %>>

                     <b class="arrow_box"></b>
                     <a href="#" title="Contribute to (R)?ex and help people in need." class="dropdown_link">Care</a>
                     <ul class="dropdown_menu dropdown_care">
                        <li><a href="/contribute">Help (R)?ex</a></li>
                        <li><a href="/contribute/donate.html">Help people in need</a></li>
                     </ul>

                  </li>
                  <li <% if($cat eq "support") { %>class="active" <% } %>><a href="/support" title="Commercial Support">Support</a></li>
                  <li <% if($cat eq "howtos" || $cat eq "modules" || $cat eq "api") { %>class="active" <% } %>>
                     <b class="arrow_box"></b>
                     <a href="#" title="Examples, Howtos and Documentation" class="dropdown_link">Docs</a>
                     <ul class="dropdown_menu dropdown_docs">
                        <li><a href="/howtos/index.html#guides">Guides</a></li>
                        <li><a href="/howtos/index.html#howtos">Howtos</a></li>
                        <li><a href="/howtos/index.html#snippets">Snippets</a></li>
                        <li>
                           <a href="/howtos/book.html">Rex Book (work in progress)</a>
                        </li>
                        <li><a href="/howtos/faq.html">FAQ</a></li>
                        <li class="divider"></li>
                        <li><a href="/api/index.html">API</a></li>
                        <li class="divider"></li>
                        <li><a href="http://rex.perl-china.com/">Chinese Rex Community Website</a></li>
                     </ul>
                  </li>
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

      <link href="/css/hs/tomorrow.css" rel="stylesheet"/>
      <link rel="stylesheet" href="/css/bootstrap.min.css?20130325" type="text/css" media="screen" charset="utf-8" />
      <link rel="stylesheet" href="/css/default.css?20140412" type="text/css" media="screen" charset="utf-8" />
      <script src="/js/highlight.pack.js"></script>

      <meta name="description" content="(R)?ex - manage all your boxes from a central point - Datacenter Automation and Configuration Management" />
      <meta name="keywords" content="Systemadministration, configuration-management, deployment, devops, datacenter, automation, Rex, Rexfiy, Rexfile, Example, Remote, Configuration, Management, Framework, SSH, Linux" />

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

               % for my $news_item (@{$news}) {
                 <div class="news_widget">
                    <div class="news_date"><%= $news_item->{date} %></div>
                    <div class="news_content"><%== $news_item->{text} %></div>
                 </div>

               % }



               <h2>Conferences</h2>

               <div class="news_widget">
                  <div class="news_date">2014-05-08 - 2014-05-10</div>
                  <div class="news_content"><img src="/img/linuxtag.png" style="float: left; width: 78px;" /> <p>Visit us at the <a href="http://linuxtag.de/">LinuxTag</a> in Berlin. There will be also a Rex hands-on workshop on Friday (2014-05-09).</p>
                  <p>LinuxTag is Europe's leading exhibition and conference for Linux, Free Software and Open Source.</p>
                  </div>
               </div>

               <h2>Need Help?</h2>
               <p>Rex is a pure open source project, you can find community support in the following places:</p>
               <ul>
                  <li>IRC: <a href="irc://irc.freenode.net/rex">#rex on irc.freenode.net</a></li>
                  <li>Groups: <a href="https://groups.google.com/group/rex-users/">Rex Users</a></li>
                  <li>Issues: <a href="https://github.com/RexOps/Rex/issues">on GitHub</a></li>
                  <li>Feature: you miss a <a href="/feature.html">feature</a>?</li>
               </ul>
               <p><a href="/support/index.html">Professional support</a> is also available.</p>
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


     <a href="http://github.com/RexOps/Rex"><img style="position: absolute; top: 0; right: 0; border: 0;" src="https://s3.amazonaws.com/github/ribbons/forkme_right_orange_ff7600.png" alt="Fork me on GitHub" /></a>

   <div class="clearfix"></div>
   <div class="bottom_bar">
      <a href="https://groups.google.com/group/rex-users/">Google Group</a> / <a href="http://twitter.com/RexOps">Twitter</a> / <a href="https://github.com/RexOps/Rex">GitHub</a> / <a href="http://www.freelists.org/list/rex-users">Mailinglist</a> / <a href="irc://irc.freenode.net/rex">irc.freenode.net #rex</a><span style="display: none;" id="syntax_high"> / <a href="#" id="link_syntax_high">Enable Syntax Highlighting</a></span>&nbsp;&nbsp;&nbsp;-.ô.-&nbsp;&nbsp;&nbsp;<a href="http://www.disclaimer.de/disclaimer.htm" target="_blank">Disclaimer</a></p>
   </div>

   <script type="text/javascript" charset="utf-8" src="/js/jquery.js"></script>
   <script type="text/javascript" charset="utf-8" src="/js/bootstrap.min.js"></script>
   <script type="text/javascript" charset="utf-8" src="/js/menu.js"></script>
   <script type="text/javascript" charset="utf-8" src="/js/ZeroClipboard.min.js"></script>

   <script>
      var client = new ZeroClipboard($(".copy-button"), { moviePath: "/js/ZeroClipboard.swf"});
   </script>

   <script>
      if($(window).width() <= 1100) {
         // hide API link
         $("#li_api").hide();
      }
      $(window).on('resize', function() {
       if($(window).width() <= 1100) {
         // hide API link
         $("#li_api").hide();
       }
       else {
         $("#li_api").show();
       }

      });
   </script>


<!-- Piwik -->
<script type="text/javascript">
  var _paq = _paq || [];
  _paq.push(['trackPageView']);
  _paq.push(['enableLinkTracking']);
  (function() {
    var u=(("https:" == document.location.protocol) ? "https" : "http") + "://www.rexify.org/stats/";
    _paq.push(['setTrackerUrl', u+'piwik.php']);
    _paq.push(['setSiteId', 1]);
    var d=document, g=d.createElement('script'), s=d.getElementsByTagName('script')[0]; g.type='text/javascript';
    g.defer=true; g.async=true; g.src=u+'piwik.js'; s.parentNode.insertBefore(g,s);
  })();

</script>
<noscript><p><img src="http://www.rexify.org/stats/piwik.php?idsite=1" style="border:0" alt="" /></p></noscript>
<!-- End Piwik Code -->


<script src="/js/browser.js"></script>
<script>
  hljs.tabReplace = '    ';
//  hljs.initHighlighting();
  hljs.initHighlightingOnLoad();
</script>


   </body>

</html>
