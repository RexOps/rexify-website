#!/usr/bin/env perl -w

use strict;
use warnings;

use MIME::Base64;
use Mojo::UserAgent;
use Mojo::JSON;
use Data::Dumper;

my $index_server = $ARGV[0];
my $index_port   = $ARGV[1];
my $index_dir    = $ARGV[2];

$|++;

if(! $index_server) {
   print "You have to set the server where to store the index.\n";
   exit 1;
}

if(! $index_port) {
   print "You have to set the server's port where to store the index.\n";
   exit 2;
}

if(! $index_dir) {
   print "You have to set the directory you want to index.\n";
   exit 3;
}

for my $idx (qw/webpage api/) {
   # first delete index
   print "[+] Deleting index ($idx)\n";
   _delete("/$idx/");

   # create new index
   print "[-] creating index ($idx)";
   my $tx = _put("/$idx", {
      "settings" => {
            "number_of_shards" => 1,
            "number_of_replicas" => 0
      },
   });
   if($tx->success) {
      print "\r[+] creating index ($idx)                    \n";
   }
   else {
      print "\r[!] error creating index ($idx)                   \n";
      exit 1;
   }

   # create attachment options
   print "[+] creating attachment mapping for ($idx)\n";
   _put("/$idx/attachment/_mapping", {
      "attachment" => {
         "properties" => {
            "file" => {
               "type" => "attachment",
               "fields" => {
                  "title" => { "store" => "yes" },
                  "file"  => { "term_vector" => "with_positions_offsets", "store" => "yes" }
               }
            }
         }
      }
   });
}

my @dir = ($index_dir);

print "[+] Indexing files...";
for my $d (@dir) {
   opendir(my $dh, $d);
   while(my $entry = readdir($dh)) {
      next if($entry =~ m/^\./);

      if(-d "$d/$entry") {
         push(@dir, "$d/$entry");
         next;
      }

      my $_d = "$d/$entry";
      if($_d =~ m/api\//) {
         index_api_document("$d/$entry");
      }
      else {
         index_webpage_document("$d/$entry");
      }
   }
   closedir($dh);
}

sub index_document {
   my ($idx, $doc) = @_;

   print "   [-] $doc ($idx)   ";
   my @content = eval { local(@ARGV) = ($doc); <>; };   

   my $title = "";

   for (@content) {
      if(m/^\%# no_index/) {
         print "\r   [_] $doc ($idx)   \n";
         return;
      }
      if(m/^% title '([^']+)'/) {
         $title = $1;
      }
      s/^\%.*//gms;
      s/<[^>]+>//gms;
   }

   my $base64_content = encode_base64(join("\n", @content));

   my $json = Mojo::JSON->new;
   my $fs = $doc;
   $fs =~ s/$index_dir//;
   $fs =~ s/\.ep$//;

   my $ref = {
      file  => $base64_content,
      #content  => join("\n", @content),
      fs    => $fs,
      title => $title,
   };

   my $tx = _post("/$idx/attachment/", $ref);
   #my $tx = _post("/$idx/document/", $ref);

   print "\r";
   print " "x80;

   if($tx->res->json && $tx->res->json->{ok}) {
      print "\r   [+] $doc ($idx)   \n";
   }
   else {
      print "\r   [!] $doc ($idx)   \n";
   }
}

sub index_api_document {
   my ($doc) = @_;
   index_document("api", $doc);
}

sub index_webpage_document {
   my ($doc) = @_;
   index_document("webpage", $doc);
}

sub _ua {
   my $ua = Mojo::UserAgent->new;
   return $ua;
}

sub _json {
   return Mojo::JSON->new;
}

sub _get {
   my ($self, $url) = @_;
   _ua->get("http://$index_server:$index_port$url");
}

sub _post {
   my ($url, $post) = @_;
   _ua->post("http://$index_server:$index_port$url", json => $post);
}

sub _put {
   my ($url, $put) = @_;
   _ua->put("http://$index_server:$index_port$url", _json->encode($put));
}

sub _delete {
   my ($url) = @_;
   my $tx = _ua->build_tx(DELETE => "http://$index_server:$index_port$url");
   _ua->start($tx);
}



