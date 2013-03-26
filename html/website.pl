#!/usr/bin/env perl -w

use strict;
use warnings;
use utf8;

use DateTime;

use Cwd qw(getcwd);
use Mojolicious::Lite;
use Mojo::UserAgent;
use Data::Dumper;

use lib 'lib';
use lib 'vendor/perl';

use DBIx::ORMapper;
use DBIx::ORMapper::Connection::Server::MySQL;
use DBIx::ORMapper::DM;

use FeatureRequest;

my $config = {};

if(-f "./config.pl") {
   my $content = eval { local(@ARGV, $/) = ("./config.pl"); <>; };
   $config  = eval 'package Foo::Config::Loader;'
                        . "no warnings; $content";

   die "Couldn't load configuration file: $@" if(!$config && $@);
   die "Config file invalid. Did not return HASH reference." if( ref($config) ne "HASH" );
}
else {
   die "Config file ./config.pl not found.";
}

plugin 'RenderFile';

DBIx::ORMapper::setup(default => "MySQL://" . $config->{database}->{server} . "/" 
                                            . $config->{database}->{schema} . 
                               "?username=" . $config->{database}->{username}  .
                               "&password=" . $config->{database}->{password}
);

eval {
   my $db = DBIx::ORMapper::get_connection("default");
   $db->connect;

   FeatureRequest->set_data_source($db);
} or do {
   die "Can't connect to database: $@";
};

sub get_random {
	my $count = shift;
	my @chars = @_;
	
	srand();
	my $ret = "";
	for(1..$count) {
		$ret .= $chars[int(rand(scalar(@chars)-1))];
	}
	
	return $ret;
}

get '/' => sub {
   my ($self) = @_;
   $self->render("index");
};

get '/feature.html' => sub {
   my ($self) = @_;

   my @op = ('+', '-');
   $self->session->{question} = int(rand(10)) . $op[int(rand(2))] . int(rand(10));

   my $wishes = FeatureRequest->all;

   my $posted = $self->param("posted")?"Your feature request has been posted successfully.":"";
   $self->render("feature", wishes => $wishes, question => $self->session->{question}, email => "", feature => "", error => 0, posted => $posted, no_disqus => 1);
};

post '/feature.html' => sub {
   my ($self) = @_;

   my $wishes = FeatureRequest->all;

   my @error = ();

   my $answer = eval $self->session->{question};
   if($self->param("question") ne $answer) {
      push(@error, "The magic answer is wrong. Please try again.");
   }

   if(! $self->param("feature")) {
      push(@error, "Please fill out the feature field.");
   }

   if(! @error) {

      my $new_wish = FeatureRequest->new(
         created => DateTime->now,
         email   => $self->param("email")   || "<not given>",
         feature => $self->param("feature") || "<not given>",
      );

      $new_wish->save;

      return $self->redirect_to('/feature.html?posted=1');
   }
   else {
      my @op = ('+', '-');
      $self->session->{question} = int(rand(10)) . $op[int(rand(2))] . int(rand(10));

      $self->render("feature", 
                        wishes   => $wishes, 
                        question => $self->session->{question}, 
                        email    => $self->param("email"), 
                        feature  => $self->param("feature"), 
                        error    => \@error, 
                        posted   => 0,
                        no_disqus => 1,
      );
   }
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

   if(-f "public/$template") {
      return $self->render_file(filepath => "public/$template", no_disqus => 0);
   }

   if(-d "templates/$template") {
      return $self->redirect_to("$template/index.html");
   }

   if(-f "templates/$template.ep") {
      $template =~ s/\.html$//;
      $self->render($template, no_disqus => 0);
   }
   else {
      $self->render('404', status => 404, no_disqus => 1);
   }

};


app->start;

__DATA__

@@ search.html.ep

% if( $hits->{total} == 0 ) {

<p>I'm sorry. Your query had no results!</p>

% } else {

% my @api_results     = grep { $_->{_index} eq "api" } @{ $hits->{hits} };
% my @webpage_results = grep { $_->{_index} eq "webpage" } @{ $hits->{hits} };

% if(@api_results) {
<h1>API</h1>
   <ul class="simple-list">
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
   <ul class="simple-list">
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

<h1>&nbsp;</h1>
<div class="small-vspace"></div>
<a href="#" class="search_button">Close</a>
<div class="small-vspace"></div>

% }

@@ 404.html.ep

% layout 'default';
% title '404 - File not found';

<h1>404 - I'm really sorry :(</h1>
<p>Hello. I'm a Webserver. And i'm there to serve files for you. But i'm really sorry :( I can't find the file you want to see.</p>

@@ navigation.html.ep

nav

@@ layouts/frontpage.html.ep
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

   </head>
   <body>

      <div id="page">

         <div id="top-div">
            <h1>(R)?ex <small>Deployment &amp; Configuration Management</small></h1>
         </div>

         <div id="head-div">
            <div class="head_container">
               <div class="slogan">
                  <h1>Automate Everything, Relax Anytime</h1>
                  <div class="slogan_list">
                     <ul>
                        <li>&gt; Integrated seamless in your running Environment</li>
                        <li>&gt; Easy to use and extend</li>
                        <li>&gt; Easy to learn, it's just plain Perl</li>
                        <li>&gt; Apache 2.0 Licensed</li>
                     </ul>
                  </div> <!-- slogan_list -->

                  <div class="source">
                     <pre><code class="perl">task prepare => sub {
   install "apache2";
   service apache2 => ensure => "started";
};</code></pre>
                  </div> <!-- source -->
                  <a class="headlink" href="#">Read the Getting Started Guide</a>
               </div> <!-- slogan -->

            </div> <!-- head_container -->
         </div>

         <div id="nav-div">
            <div class="nav_title">
               <span style="color: #7b4d29;">Y</span>our <span style="color: #7b4d29;">W</span>ay
            </div>
            <div class="nav_links">
               <ul>
                  <li class="active"><a href="#">Home</a></li>
                  <li><a href="#">Get Rex</a></li>
                  <li><a href="#">Contribute</a></li>
                  <li><a href="#">Docs</a></li>
                  <li><a href="#">API</a></li>
               </ul>
            </div>
         </div>

         <div id="widgets_container">
            <div id="widgets">
               <h2>News</h2>
               <div class="news_widget">
                  <div class="news_date">2013-03-16</div>
                  <div class="news_content">Talk from the German Perl Workshop just got uploaded to slideshare (<a href="http://de.slideshare.net/jfried/von-test-nach-live-mit-rex">german</a>) and (<a href="http://de.slideshare.net/jfried/from-test-to-live-with-rex">english</a>).</div>
               </div>

               <div class="news_widget">
                  <div class="news_date">2013-02-24</div>
                  <div class="news_content">(R)?ex 0.40.0 released. This release added a common CMDB interface and a simple CMDB on YAML file basis. Read the <a href="https://github.com/krimdomu/Rex/wiki/New0.40">ChangeLog</a> for all changes.</div>
               </div>

               <div class="news_widget">
                  <div class="news_date">2013-01-27</div>
                  <div class="news_content">(R)?ex 0.39.0 released. This release adds support for private module servers and fixes bugs. See <a href="https://github.com/krimdomu/Rex/wiki/New0.39">ChangeLog</a> for more information.</div>
               </div>


               <h2>Conferences</h2>
               <img src="/img/osdc.png" style="float: left; width: 100px;" />
               <p><a href="http://www.osdc.de/">Open Source Data Center Conference</a></p>
               <p style="padding-top: 6px;">17 - 18 April 2013 in Nuremberg</p>
               <p>OSDC is about simplifying complex IT infrastructures with Open Source. A rare opportunity to meet with Open Source professionals and insiders, gather and share information over 2 days of presentations, hands-on workshops and social networking.</p>

               <h2>Awards</h2>
               <img src="/img/init_mittelstand.png" style="float: left;" />
               <p>We are proud to announce that Rex was voted under the Best Open Source solutions 2013 by <a href="http://www.imittelstand.de/">initiative mittelstand</a>. And we want to thank <a href="http://inovex.de">inovex</a> for the support to make this happen.</p>

<p>Inovex is an owner-managed IT project company employing over 120 people at its four sites in Pforzheim, Karlsruhe, Munich and Cologne. Our excellent IT engineers and architects support IT departments in large companies and Internet firms with their expertise at managing the crucial tasks that occur in Internet environments. Inovex helps leading internet companies, like 1&1 Internet AG (WEB.DE, GMX), buch.de and maxdome, IT departments in traditional industry (such as Bosch, Daimler, Porsche and Volkswagen) and other leading industrial companies like EnBW or DB Schenker, to deal with their IT challenges.</p>
            </div>
         </div> <!-- widgets -->

         <div id="content_container">
            <div id="content">
               <%= content %>
            </div>
         </div> <!-- content -->

      </div> <!-- page -->
      

     <a href="http://github.com/Krimdomu/Rex"><img style="position: absolute; top: 0; right: 0; border: 0;" src="https://s3.amazonaws.com/github/ribbons/forkme_right_orange_ff7600.png" alt="Fork me on GitHub" /></a>



   <script type="text/javascript" charset="utf-8" src="/js/jquery-1.5.2.min.js"></script>

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
</script>


   </body>

</html>

