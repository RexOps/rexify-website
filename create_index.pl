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

# first delete index
print "[+] Deleting index\n";
_delete("/webpage/");

# create new index
print "[+] creating index\n";
_put("/webpage", {"settings" => { "index" => { "number_of_shards" => 1, "number_of_replicas" => 0 }}});

# create attachment options
print "[+] creating attachment mapping\n";
_put("/webpage/attachment/_mapping", {
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

      index_document("$d/$entry");
   }
   closedir($dh);
}

sub index_document {
   my ($doc) = @_;

   print "   [-] $doc    ";
   my @content = eval { local(@ARGV) = ($doc); <>; };   

   my $title = "";

   for (@content) {
      if(m/^\%# no_index/) {
         print "\r   [_] $doc    \n";
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
   my $ref = {
      file  => $base64_content,
      fs    => $doc,
      title => $title,
   };

   my $tx = _post("/webpage/attachment/", $ref);

   print "\r";
   print " "x80;

   if($tx->res->json && $tx->res->json->{ok}) {
      print "\r   [+] $doc    \n";
   }
   else {
      print "\r   [!] $doc    \n";
   }
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
   _ua->post_json("http://$index_server:$index_port$url", $post);
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



