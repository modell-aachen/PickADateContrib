#!/usr/bin/perl -w
BEGIN { unshift @INC, split( /:/, $ENV{FOSWIKI_LIBS} ); }
use Foswiki::Contrib::Build;

$build = new Foswiki::Contrib::Build('PickADateContrib');
$build->build($build->{target});

