#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 3;

package MyGrammar::RNG;

use Any::Moose;

use File::Spec;

with ('XML::GrammarBase::Role::RelaxNG');

has '+module_base' => (default => 'XML::GrammarBase');
has '+data_dir' => (default => File::Spec->catdir(File::Spec->curdir(), "t", "data"));
has '+rng_schema_basename' => (default => 'fiction-xml.rng');

package main;

{
    my $rng = MyGrammar::RNG->new();

    my $xml_parser = XML::LibXML->new();
    $xml_parser->validation(0);

    my $dom = $xml_parser->parse_file(
        File::Spec->catfile(
            File::Spec->curdir(), "t", "data", "fiction-xml-test.xml"
        )
    );
    eval {
        $rng->rng_validate_dom($dom);
    };

    # TEST
    is ($@, '', 'No exception was thrown.');
}

{
    my $rng = MyGrammar::RNG->new();

    eval {
        $rng->rng_validate_file(
            File::Spec->catfile(
                File::Spec->curdir(), "t", "data", "fiction-xml-test.xml"
            )
        );
    };

    # TEST
    is ($@, '', 'No exception was thrown.');
}

sub _slurp
{
    my $filename = shift;

    open my $in, '<', $filename
        or die "Cannot open '$filename' for slurping - $!";

    binmode $in, ':encoding(utf8)';

    local $/;
    my $contents = <$in>;

    close($in);

    return $contents;
}

{
    my $rng = MyGrammar::RNG->new();

    eval {
        $rng->rng_validate_string(
            _slurp(
                File::Spec->catfile(
                    File::Spec->curdir(), "t", "data", "fiction-xml-test.xml"
                )
            ),
        );
    };

    # TEST
    is ($@, '', 'No exception was thrown.');
}
