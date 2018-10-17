package Site;

use Mojo::Base 'Pitahaya::PageType';
use version;

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
    "/howtos/perl.html" => "/docs/guides/just_enough_perl_for_rex.html",
    "/contribute" => "/care/help__r__ex.html",
    "/contribute/donate.html" => "/care/help_people_in_need.html",
    "/howtos/index.html" => "/docs.html",
    "/howtos/faq.html" => "/docs/faq.html",
    "/howtos/start.html" => "/docs/guides/start_using__r__ex.html",
  );

  if(exists $redir_map{$url}) {
    $self->controller->res->code(301);
    $self->controller->redirect_to($redir_map{$url});
  }
  elsif($url =~ m/^\/api\/(.*)/) {
    # api page call
    my $api_part = $1;
    my $api_root = $self->site->get_page(29);
    my @children = $api_root->children;
    my ($newest) = sort { version->parse("v" . $b->name) <=> version->parse("v" . $a->name) } @children;
    
    my $api_url = $newest->generate_url;
    $api_url =~ s/\.html$//;
    $api_url .= "/$api_part";
    
    $self->controller->res->code(302);
    $self->controller->redirect_to(lc($api_url));
  }
  else {
    $self->controller->stash("news" => []);
    $self->controller->stash("trainings" => []);
    $self->controller->stash("cat" => 'home');
    $self->controller->stash("no_disqus" => 1);
    $self->controller->stash("no_side_bar" => 0);
    $self->controller->stash("root" => 0);

    $self->controller->stash(page => $self->site->get_page(1));
    $self->controller->res->code(404);
    $self->controller->render("skin/rexify.org/404");
  }
}

1;
