use strict;
use warnings;
use Test::More;
use Mojolicious::Lite;
use Test::Mojo::Trim;

plugin 'BootstrapHelpers4';

my $test = Test::Mojo::Trim->new;

ok 1;

get '/label' => 'label';

$test->get_ok('/label')->status_is(200)->trimmed_content_is('<span class="label label-warning">hi</span>', 'Correct label');

done_testing;

__DATA__

@@ label.html.ep

%= label 'hi', qwr('warning')
