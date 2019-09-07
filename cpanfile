requires 'HTML::Entities';
requires 'HTML::Lint::Pluggable';
requires 'Statocles';
requires 'Syntax::Highlight::Engine::Kate';
requires 'Text::MultiMarkdown';

on develop => sub {
  requires 'Path::Tiny';
  requires 'Perl::Tidy';
}
