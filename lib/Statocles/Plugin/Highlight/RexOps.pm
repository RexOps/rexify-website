package Statocles::Plugin::Highlight::RexOps;
our $VERSION = '0.001';

# ABSTRACT: Highlight code for rexify-website

=head1 SYNOPSIS

    # --- Configuration
    # site.yml
    ---
    site:
        class: Statocles::Site
        args:
            plugins:
                highlight:
                    $class: Statocles::Plugin::Highlight::RexOps

    # --- Usage
    ```perl
    print "Hello, World!\n";
    ```

=head1 DESCRIPTION

This plugin is based on Statocles::Plugin::Highlight

It preprocesses each document and replaces fenced code blocks with HTML
fragments for syntax highlighting.

=cut

use Statocles::Base 'Class';
with 'Statocles::Plugin';

use List::Util qw(first);

BEGIN {
    eval { require Syntax::Highlight::Engine::Kate; 1 }
      or die
      "Error loading Statocles::Plugin::Highlight::RexOps. To use this plugin, install Syntax::Highlight::Engine::Kate";
}

my $hl = Syntax::Highlight::Engine::Kate->new(
    substitutions => {
        "<" => "&lt;",
        ">" => "&gt;",
        "&" => "&amp;",
    },
    format_table => {
        Alert        => [ '',                             '' ],
        BaseN        => [ '<span class="hljs-number">',   '</span>' ],
        BString      => [ '',                             '' ],
        Char         => [ '<span class="hljs-string">',   '</span>' ],
        Comment      => [ '<span class="hljs-comment">',  '</span>' ],
        DataType     => [ '<span class="hljs-type">',     '</span>' ],
        DecVal       => [ '<span class="hljs-number">',   '</span>' ],
        Error        => [ '',                             '' ],
        Float        => [ '<span class="hljs-number">',   '</span>' ],
        Function     => [ '<span class="hljs-function">', '</span>' ],
        IString      => [ '',                             '' ],
        Keyword      => [ '<span class="hljs-keyword">',  '</span>' ],
        Normal       => [ '',                             '' ],
        Operator     => [ '',                             '' ],
        Others       => [ '',                             '' ],
        RegionMarker => [ '',                             '' ],
        Reserved     => [ '<span class="hljs-built-in">', '</span>' ],
        String       => [ '<span class="hljs-string">',   '</span>' ],
        Variable     => [ '<span class="hljs-variable">', '</span>' ],
        Warning      => [ '',                             '' ],
    },
);

sub highlight_fenced_code_blocks {
    my ( $self, $pages, @args ) = @_;

    for my $page ( @{ $pages->pages } ) {
        next unless $page->isa('Statocles::Page::Document');

        my $markdown = $page->document->content;

        $markdown =~ s/
      (?<indent>[ \t]*)
      (?<fence>```)
      (?<info>\w*)
      (?<codeblock>.+?)
      \g{fence}
    /
      $self->highlight($+{codeblock}, $+{info}, $+{indent});
    /egsx;

        $page->document->content($markdown);
    }
}

sub highlight {
    my ( $self, $text, $info, $indent ) = @_;
    my $html_indent = $indent =~ s/^(    |\t)//r; # reduce indent level by one

    if ($info) {
        my $lang = first { lc $_ eq lc $info } $hl->languageList;

        if ( !$lang ) {
            die sprintf qq{Could not find language "%s"\n}, $info;
        }

        $hl->language($lang);
    }

    $text =~ s/^$indent//gm;    # remove code block indent
    $text =~ s/\A\n+|\n+\z//gm; # clean up leading/trailing newlines

    my $highlighted_text = $hl->highlightText($text);
    $highlighted_text =~ s/^/&#8288;/gm; # add a WORD JOINER character to each line

    my $wrap_start = qq($html_indent<pre><code class="hljs">);
    my $wrap_end   = qq($html_indent</code></pre>);
    my $output     = $wrap_start . $highlighted_text . $wrap_end;

    return $output;
}

=method register

Register this plugin with the site. Called automatically.

=cut

sub register {
    my ( $self, $site ) = @_;
    $site->on( collect_pages => sub { $self->highlight_fenced_code_blocks(@_) } );
}

1;
__END__

=head1 SUPPORTED SYNTAX

All of the syntax types supported by the L<Syntax::Highlight::Engine::Kate> Perl module
are supported by this module.

=head1 SEE ALSO

=over 4

=item L<Syntax::Highlight::Engine::Kate>

The underlying syntax highlighter powering this plugin

=cut

=back
