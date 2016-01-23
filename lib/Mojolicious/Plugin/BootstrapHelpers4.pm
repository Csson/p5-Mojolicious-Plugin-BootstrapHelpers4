use 5.20.0;
use strict;
use warnings;

package Mojolicious::Plugin::BootstrapHelpers4 {

    # VERSION
    # ABSTRACT: Type less Bootstrap (v4)

    use Mojo::Base 'Mojolicious::Plugin';
    use Module::Load qw/load/;
    use experimental qw/signatures postderef/;

    sub register($self, $app, $args) {

        my $helpers = {
            cdn => ['Mojolicious::Plugin::BootstrapHelpers4::Component::CDN'],
            button => ['Mojolicious::Plugin::BootstrapHelpers4::Component::Button', type => 'button'],
            submit => ['Mojolicious::Plugin::BootstrapHelpers4::Component::Button', type => 'submit'],
            label => ['Mojolicious::Plugin::BootstrapHelpers4::Component::Label'],
            table => ['Mojolicious::Plugin::BootstrapHelpers4::Component::Table'],
        };

        $app->helper(qwr => sub { \[split /\s+/ => $_[1]] });
        for my $helper (keys $helpers->%*) {
            my @attributes = $helpers->{ $helper }->@*;
            my $class = shift @attributes;
            load $class;
            $app->helper($helper => sub { $class->new($helpers, \@attributes, @_)->create });
        }
    }

}

1;

__END__

=pod

=head1 SYNOPSIS

    # Mojolicious
    $self->plugin('BootstrapHelpers4');

    # ::Lite
    plugin 'BootstrapHelpers4';

=head1 STATUS

Unstable. Breaking changes might occur between minor versions.

=head1 DESCRIPTION

Mojolicious::Plugin::BootstrapHelpers4 is a convenience plugin that reduces some bootstrap complexity by introducing several tag helpers specifically for L<Bootstrap 4|http://www.getbootstrap.com/>.

The goal is not to have tag helpers for everything, but for common use cases.

All examples below (and more, see tests) is expected to work.

If you are using Bootstrap 3, see L<Mojolicious::Plugin::BootstrapHelpers>.

=head2 Changes from Mojolicious::Plugin::BootstrapHelpers

...

=head1 Components

The following components are available:

=for :list
* L<button|Mojolicious::Plugin::BootstrapHelpers4::Component::Button>
* L<label|Mojolicious::Plugin::BootstrapHelpers4::Component::Label>
* L<table|Mojolicious::Plugin::BootstrapHelpers4::Component::Table>

=head1 SEE ALSO

=cut
