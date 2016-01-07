use 5.20.0;
use strict;
use warnings;

package Mojolicious::Plugin::BootstrapHelpers4::Component {

    # VERSION
    # ABSTRACT: Short intro

    use MooseX::Role::Parameterized;
    use MooseX::AttributeShortcuts;
    use Types::Standard -types;
    use Mojolicious::Plugin::BootstrapHelpers4::Util qw/out parse_data_hash/;
    use Carp;
    use Module::Load qw/load/;
    use List::Compare;
    use namespace::autoclean;
    use syntax 'maybe';
    use syntax 'junction';
    use experimental qw/postderef signatures/;

    requires qw/create allowed_settings/;

    parameter require => (
        isa => ArrayRef,
        traits => ['Array'],
        default => sub { [ ] },
        handles => {
            requires => 'first',
        },
    );
    parameter optional => (
        isa => ArrayRef,
        traits => ['Array'],
        default => sub { [ ] },
        handles => {
            optionally => 'first',
        },
    );

    # 'content' is *either* 'title' or 'body'
    # and can't be used with any of those.
    # It also can't be optional, as opposed to
    # 'title' and 'body'.
    has content => (
        is => 'ro',
        isa => Any,
        predicate => 1,
    );
    has title => (
        is => 'ro',
        isa => Str,
        predicate => 1,
    );
    has body => (
        is => 'ro',
        isa => Any,
        predicate => 1,
    );
    
    has list => (
        is => 'ro',
        isa => ArrayRef,
        default => sub { [undef] },
        traits => ['Array'],
        handles => {
            count_in_list => 'count',
            get_in_list => 'get',
        },
    );
    has settings => (
        is => 'ro',
        isa => ArrayRef[Str],
        traits => ['Array'],
        default => sub { [ ] },
        handles => {
            get_setting => 'get',
            add_setting => 'push',
            has_settings => 'count',
            all_settings => 'elements',
            first_setting => 'first',
            filter_settings => 'grep',
        },
    );
    has pairs => (
        is => 'ro',
        isa => ArrayRef[ Map[Str, Any] ],
        default => sub { [ ] },
        traits => ['Array'],
        handles => {
            all_pairs => 'elements',
        },
    );
    # even though 'data' keys are intermingled with 'pairs',
    # we separate them in BUILDARGS to simplify component
    # creation
    has data => (
        is => 'ro',
        isa => ArrayRef,
        default => sub { [ ] },
        traits => ['Array'],
        handles => {
            all_datas => 'elements',
            has_data => 'count',
            get_data => 'get',
            count_data => 'count',
        },
    );
    
    has loaded => (
        is => 'ro',
        isa => ArrayRef,
        traits => ['Array'],
        default => sub { [ ] },
        handles => {
            module_loaded => 'first',
            add_loaded => 'push',
        },
    );
    has controller => (
        is => 'ro',
        isa => InstanceOf['Mojolicious::Controller'],
        required => 1,
    );
    
    has bootstrap_helpers => (
        is => 'ro',
        isa => HashRef,
        traits => ['Hash'],
        default => sub { { } },
        handles => {
            get_helper_class => 'get',
        },
    );

    role {
        my $p = shift;

        around BUILDARGS => sub ($next, $class, $helpers, $attributes, $controller, @args) {

            my $content = undef;
            my $title = undef;
            my $body = undef;
            my $list = [];
            my $settings = [];
            my $pairs = [];
            my $datas = [];

            if(!$class->check_might_have(@args)) {
                confess "Incorrect bootstrap require/optional (likely 'content' + 'body' or 'title')";
            }

            if($class->must_have('content')) {
                $content = ref $args[-1] eq 'CODE' ? (pop @args)->() : shift @args;
            }
            else {
                if($class->might_have('body') && ref $args[-1] eq 'CODE') {
                    $body = (pop @args)->();
                }
                if($class->might_have('title')) {
                    if($class->must_have('list') && none(qw/ARRAY REF/) eq ref $args[0]) {
                        $title = shift @args;
                    }
                    elsif(scalar @args % 2 == 1 && none(qw/ARRAY REF/) eq ref $args[0]) {
                        $title = shift @args;
                    }
                    elsif($class->must_have('title') ) {
                        confess "Incorrect bootstrap usage, expects a title but not enough arguments";
                    }
                }
            }

            if($class->might_have('list')) {
                if(ref $args[0] eq 'ARRAY') {
                    $list = shift @args;
                }
            }

            if($class->might_have('settings')) {
                if(ref $args[0] eq 'REF' && ref $args[0]->$* eq 'ARRAY') {
                    my $temporary_settings = (shift @args)->$*;
                    $settings = [List::Compare->new([$class->allowed_settings], $temporary_settings)->get_intersection];
                }
            }

            if(scalar @args % 2) {
                confess "Incorrect bootstrap usage, expects a list of pairs but got a list with @{[ scalar @args ]} elements";
            }

            if($class->might_have('pairs') && scalar @args % 2 == 0) {
                for (my $i = 0; $i < scalar @args; $i += 2) {
                    my $key = $args[$i];
                    my $value = $args[$i + 1];

                    #    data => { key => 'value', anotherkey => 'another_value', nested => { key => 'stuff' } }
                    # -> data-key => 'value', data-anotherkey => 'another_value', data-nested-key => 'stuff'
                    if($key eq 'data') {
                        push @$datas => parse_data_hash('data', $value);
                    }

                # Maybe?
=pod comment
                   # eg: -button => [...]
                   if(index($value, '-') == 0) {
                       my $class = join '::' => 'Mojolicious::Plugin::BootstrapHelpers4::Component', ucfirst $key;

                        if(!$class->module_loaded(sub { $_ eq $class })) {
                            load $class;
                            $class->add_loaded($class);
                        }
                        $args[$i] = $class->new($value->@*)->create;
                    }
=cut
                }
            }

            $class->$next(
                      @$attributes,
                      bootstrap_helpers => $helpers,
                      controller => $controller,
                maybe content => $content,
                maybe title => $title,
                maybe body => $body,
                      list => $list,
                      settings => $settings,
                      pairs => $pairs,
                      data => $datas,
            );

        };
        method must_have => sub ($class, $value) {
            return $p->requires(sub { $_ eq $value }) ? 1 : 0;
        };
        method might_have => sub ($class, $value) {
            return $p->requires(sub { $_ eq $value }) || $p->optionally(sub { $_ eq $value }) ? 1 : 0;
        };
        method check_might_have => sub ($class, @args) {
            # content can't be used with title or body
            if($class->might_have('content') && ($class->might_have('title') || $class->might_have('body'))) {
                return 0;
            }
            return 1;
        };
        method find_setting => sub ($self, $setting) {
            return $self->first_setting(sub { $_ eq $setting });
        };
        method data_string => sub ($self) {
            return '' if !$self->has_data;

            my @datas;
            for (my $i = 0; $i < $self->count_data; $i += 2) {
                my $attr = $self->get_data($i);
                my $value = $self->get_data($i + 1);
                push @datas => qq{$attr="$value"};
            }
            return join ' ' => @datas;
        };
        method url_for => sub ($self, $url) {
            return '' if ref $url ne 'ARRAY';
            return $url->[0] if scalar @$url == 1 && index($url-[0], '#') == 0;
            my $controller = $self->controller;
            return $controller->url_for(@$url)->to_string;
        };
        method attr2html => sub ($self, $attr) {
            return '' if !scalar keys %$attr;

            # scalar reference implies attribute without value, such as 'disabled'
            return ' ' . join ' ' => map {
                                          ref $attr->{ $_ } eq 'SCALAR' ? $_
                                        : ref $attr->{ $_ } eq 'ARRAY'  ? qq{$_="$attr->{ $_ }->@*"}
                                        :                                 qq{$_="$attr->{ $_ }"}
                                    } sort keys %$attr;
        };
        method has_list => sub ($self) {
            return $self->count_in_list && defined $self->get_in_list(0) ? 1 : 0;
        }
    };
}

1;    
    