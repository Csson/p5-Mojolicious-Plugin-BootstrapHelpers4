use 5.20.0;
use strict;
use warnings;

package Mojolicious::Plugin::BootstrapHelpers4::Component::Label {

    # VERSION
    # ABSTRACT: Short intro

    use Mojolicious::Plugin::BootstrapHelpers4::Elk;
    use namespace::autoclean;
    use experimental qw/postderef signatures/;

    with 'Mojolicious::Plugin::BootstrapHelpers4::Component' => { require => [qw/content/], optional => [qw/settings/] };

    sub allowed_settings {
        qw/
            pill
            default
            primary
            success
            info
            warning
            danger
        /;
    }

    sub create($self) {
        return out() if !$self->has_content;

        if(!$self->has_settings) {
            $self->add_setting('default');
        }
        my @classes = ('label', map { sprintf 'label-%s', $_ } $self->all_settings);

        return out(qq{
            <span class="@{[ join ' ' => sort @classes ]}">@{[ $self->content ]}</span>
        });
    }

    __PACKAGE__->meta->make_immutable;

}

1;

__END__

<%= card items => [
            img => []
            block => [
                h4 => 'Ze title',
                h6 => 'Sub title'
                p => 'This wider card...',
                p => '...is wide',
                html => ['<p>Whatev</p>'],
            ],
            img => []
] %>