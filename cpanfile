requires 'HTML::Entities';
requires 'Statocles';
requires 'Syntax::Highlight::Engine::Kate';
requires 'Text::MultiMarkdown';

on develop => sub {
  requires 'Path::Tiny';
  requires 'Perl::Tidy';
}
