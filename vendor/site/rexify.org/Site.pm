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

1;
