use 5.20.0;
use strict;
use warnings;

package Mojolicious::Plugin::BootstrapHelpers4::Elk {

    use Moose();
    use MooseX::AttributeShortcuts();
    use Types::Standard -types;
    use Mojolicious::Plugin::BootstrapHelpers4::Util qw/out/;
    use Moose::Exporter;
    use experimental qw/postderef signatures/;

    Moose::Exporter->setup_import_methods(also => ['Moose'], as_is => [qw/Str Enum out/]);

    sub init_meta($class, @args) {
        my %params = @args;
        my $for_class = $params{'for_class'};
        Moose->init_meta(@args);
        MooseX::AttributeShortcuts->init_meta(for_class => $for_class);
    }

}

1;