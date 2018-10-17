package Admin::Desktop;

use Mojo::Base 'Pitahaya::PageType';
use version;
use Amazon::CloudFront::Thin;

sub clear_cloudfront {
  my ($self) = shift;
  
  my @pages = $self->site->pages;
  my @urls;
  for my $p (@pages) {
    push @urls, $p->generate_url;
  }
  
  my $cloudfront = Amazon::CloudFront::Thin->new({
    aws_access_key_id     => $self->controller->config->{aws_access_key},
    aws_secret_access_key => $self->controller->config->{aws_secret_key},
    distribution_id       => $self->controller->config->{aws_cloudfront_id},
  });
  
  my $res = $cloudfront->create_invalidation(@urls);
  if($res->is_success) {
    return $self->controller->render(json => {ok => Mojo::JSON->true});
  }
  
  $self->controller->render(json => {ok => Mojo::JSON->false});
}

1;
