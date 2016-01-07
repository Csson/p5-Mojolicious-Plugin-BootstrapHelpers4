# NAME

Mojolicious::Plugin::BootstrapHelpers4 - Type less Bootstrap (v4)

![Requires Perl 5.20](https://img.shields.io/badge/perl-5.20-brightgreen.svg) [![Travis status](https://api.travis-ci.org/Csson/p5-Mojolicious-Plugin-BootstrapHelpers4.svg?branch=master)](https://travis-ci.org/Csson/p5-Mojolicious-Plugin-BootstrapHelpers4)

# VERSION

Version 0.0001, released 2016-01-07.

# SYNOPSIS

    # Mojolicious
    $self->plugin('BootstrapHelpers4');

    # ::Lite
    plugin 'BootstrapHelpers4';

# STATUS

Unstable. Breaking changes might occur between minor versions.

# DESCRIPTION

Mojolicious::Plugin::BootstrapHelpers4 is a convenience plugin that reduces some bootstrap complexity by introducing several tag helpers specifically for [Bootstrap 4](http://www.getbootstrap.com/).

The goal is not to have tag helpers for everything, but for common use cases.

All examples below (and more, see tests) is expected to work.

If you are using Bootstrap 3, see [Mojolicious::Plugin::BootstrapHelpers](https://metacpan.org/pod/Mojolicious::Plugin::BootstrapHelpers).

## Changes from Mojolicious::Plugin::BootstrapHelpers

...

# Components

The following components are available:

- [button](https://metacpan.org/pod/Mojolicious::Plugin::BootstrapHelpers4::Component::Button)
- [label](https://metacpan.org/pod/Mojolicious::Plugin::BootstrapHelpers4::Component::Label)
- [table](https://metacpan.org/pod/Mojolicious::Plugin::BootstrapHelpers4::Component::Table)

# SEE ALSO

# SOURCE

[https://github.com/Csson/p5-Mojolicious-Plugin-BootstrapHelpers4](https://github.com/Csson/p5-Mojolicious-Plugin-BootstrapHelpers4)

# HOMEPAGE

[https://metacpan.org/release/Mojolicious-Plugin-BootstrapHelpers4](https://metacpan.org/release/Mojolicious-Plugin-BootstrapHelpers4)

# AUTHOR

Erik Carlsson <info@code301.com>

# WHat

This software is copyright (c) 2016 by Erik Carlsson.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

Bootstrap itself is (c) Twitter. See [their license information](http://getbootstrap.com/getting-started/#license-faqs).

[Mojolicious::Plugin::BootstrapHelpers4](https://metacpan.org/pod/Mojolicious::Plugin::BootstrapHelpers4) is third party software, and is not endorsed by Twitter.
