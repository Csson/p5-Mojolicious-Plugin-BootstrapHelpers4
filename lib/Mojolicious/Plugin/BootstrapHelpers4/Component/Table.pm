use 5.20.0;
use strict;
use warnings;

package Mojolicious::Plugin::BootstrapHelpers4::Component::Table {

    # VERSION
    # ABSTRACT: Short intro

    use Mojolicious::Plugin::BootstrapHelpers4::Elk;
    use namespace::autoclean;
    use experimental qw/postderef signatures/;

    with 'Mojolicious::Plugin::BootstrapHelpers4::Component' => { optional => [qw/title body settings pairs/] };

    sub allowed_settings {
        qw/
            inverse
            striped
            bordered
            hover
            sm
            responsive
            reflow
        /
    }

    sub create($self) {
        my $add_responsive = $self->find_setting('responsive') ? 1 : 0;
        my @classes = ('table', map { sprintf 'table-%s', $_ } $self->filter_settings(sub { $_ ne 'responsive' }));


        my $table = qq{
            <table class="@{[ join ' ' => sort @classes ]}"@{[ $self->data_string ]}>
                @{[ $self->body // '' ]}
            </table>
        };

        if($add_responsive) {
            $table = qq{<div class="table-responsive">$table</div>};
        }
        return out($table);
    }

    __PACKAGE__->meta->make_immutable;

}

1;
