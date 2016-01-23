use 5.20.0;
use strict;
use warnings;

package Mojolicious::Plugin::BootstrapHelpers4::Component::Button {

    # VERSION
    # ABSTRACT: Short intro

    use Mojolicious::Plugin::BootstrapHelpers4::Elk;
    use namespace::autoclean;
    use syntax 'junction';
    use experimental qw/postderef signatures/;

    has type => (
        is => 'ro',
        isa => Enum[qw/button submit/],
        required => 1,
    );
    

    with 'Mojolicious::Plugin::BootstrapHelpers4::Component' => { require => [qw/content/], optional => [qw/list settings pairs/] };

    sub allowed_settings {
        qw/
            primary
            secondary
            success
            info
            warning
            danger
            link
            primary-outline
            secondary-outline
            success-outline
            info-outline
            warning-outline
            danger-outline
            lg
            sm
            block
            active
            disabled
            toggle
        /
    }

    sub create($self) {

        my @appearance_settings = $self->filter_settings(sub { none(qw/lg sm disabled block active toggle/) eq $_ });
        my @size_settings = $self->filter_settings(sub { any(qw/lg sm/) eq $_ });
        my @misc_settings = $self->filter_settings(sub { none(@appearance_settings, @size_settings) eq $_ });

        push @appearance_settings => 'primary' if !scalar @appearance_settings;
        my @classes = ('btn', sort map { sprintf 'btn-%s', $_ } (@appearance_settings, @size_settings));
        push @classes => sort grep !/disabled/ => @misc_settings;
        my $attr = { class => \@classes };

        my $button;

        # We have an url -> make an <a>
        if($self->type eq 'button' && $self->has_list) {
            push $attr->{'class'}->@* => 'disabled' if $self->find_setting('disabled') && $self->type eq 'button';
            $attr->{'role'} = 'button';
            $attr->{'aria-pressed'} = 'true' if $self->find_setting('active');
            $attr->{'href'} = $self->url_for($self->list) if $self->has_list;

            $button = qq{
                <a@{[ $self->attr2html($attr) ]}>@{[ $self->content ]}</a>
            };
        }
        else {
            $attr->{'type'} = $self->type eq 'button' ? 'button' : 'submit';
            $attr->{'disabled'} = \'' if $self->find_setting('disabled');

            if($self->find_setting('toggle')) {
                $attr->{'data-toggle'} = 'button';
                $attr->{'aria-pressed'} = $self->find_setting('active') ? 'true' : 'false';
            }

            if($self->type eq 'button') {
                $button = qq{
                    <button@{[ $self->attr2html($attr) ]}>@{[ $self->content ]}</button>
                };
            }
            else {
                $attr->{'value'} = $self->content;
                $button = qq{
                    <input@{[ $self->attr2html($attr) ]} />
                };
            }

        }
        

        return out($button);
    }

    __PACKAGE__->meta->make_immutable;

}

1;
