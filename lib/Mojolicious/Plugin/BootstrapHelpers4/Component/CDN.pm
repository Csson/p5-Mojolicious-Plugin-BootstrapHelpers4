use 5.20.0;
use strict;
use warnings;

package Mojolicious::Plugin::BootstrapHelpers4::Component::CDN {

    # VERSION
    # ABSTRACT: Short intro

    use Mojolicious::Plugin::BootstrapHelpers4::Elk;
    use namespace::autoclean;
    use syntax 'junction';
    use experimental qw/postderef signatures/;

    with 'Mojolicious::Plugin::BootstrapHelpers4::Component' => { require => [qw/title/] };

    sub allowed_settings { }

    sub create($self) {
        return out() if !$self->has_title;
        my $what = $self->title;

        my $css = q{<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.2/css/bootstrap.min.css" integrity="sha384-y3tfxAZXuh4HwSYylfB+J125MxIs6mR5FOHamPBG064zB+AFeWH94NdvaCBm8qnd" crossorigin="anonymous">};
        my $js  = q{<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.2/js/bootstrap.min.js" integrity="sha384-vZ2WRJMwsjRMW/8U7i6PWi6AlO1L79snBrmgiDpgIWJ82z8eA5lenwvxbMV1PAh7" crossorigin="anonymous"></script>};
        my $jq  = q{<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>};

        return out(
               $what eq 'css' ? $css
             : $what eq 'js'  ? $js
             : $what eq 'jsq' ? $jq . $js
             : $what eq 'all' ? $css . $jq . $js
             :                  ''
        );
    }

    __PACKAGE__->meta->make_immutable;
}

1;
