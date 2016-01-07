use 5.20.0;
use strict;
use warnings;

package Mojolicious::Plugin::BootstrapHelpers4::Util {

    # VERSION
    # ABSTRACT: Short intro

    use Exporter 'import';
    use Mojo::ByteStream;
    use experimental qw/postderef signatures/;

    our @EXPORT = qw/isrefarray out/;
    our @EXPORT_OK = qw/parse_data_hash/;

    sub isrefarray($var) {
        return defined $var && ref $var eq 'REF' && ref $$var eq 'ARRAY';
    }
    sub out($tag = '') {
        return Mojo::ByteStream->new($tag);
    }
    sub parse_data_hash($base_key, $value) {
        my @datas = ();

        for my $data_key (keys $value->%*) {
            my $data_value = $value->{ $data_key };

            if(ref $data_value eq 'HASH') {
                push @datas => parse_data_hash("$base_key-$data_key", $data_value);
            }
            else {
                push @datas => ("$base_key-$data_key" => $data_value);
            }
        }
        return @datas;
    }

}

1;
