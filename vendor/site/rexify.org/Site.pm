package Site;

use Mojo::Base 'Pitahaya::PageType';

sub GET {
  my ($self) = @_;
  $self->controller->stash("news" => []);
  $self->controller->stash("trainings" => []);
  $self->controller->stash("cat" => 'home');
  $self->controller->stash("no_disqus" => 1);
  $self->controller->stash("no_side_bar" => 0);

  if($self->page->id == 1) {
    $self->controller->stash("root" => 1);
  }
  else {
    $self->controller->stash("root" => 0);
  }

}

sub page_not_found {
  my ($self) = @_;

  my $url = $self->controller->req->url;

  my %redir_map = (
    "/get" => "/get.html",
    "/howtos/perl.html" => "/docs/guides/just_enough_perl_for_rex.html",
    "/contribute" => "/care/help__r__ex.html",
    "/contribute/donate.html" => "/care/help_people_in_need.html",
    "/howtos/index.html" => "/docs.html",
    "/howtos/faq.html" => "/docs/faq.html",
  );

  if(exists $redir_map{$url}) {
    $self->controller->res->code(301);
    $self->controller->redirect_to($redir_map{$url});
  }
  else {
    $self->controller->reply->not_found();
  }
}

1;
