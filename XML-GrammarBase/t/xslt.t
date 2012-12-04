#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 5;

package MyGrammar::XSLT;

use Any::Moose;

use File::Spec;

with ('XML::GrammarBase::Role::XSLT');

has '+module_base' => (default => 'XML-GrammarBase');
has '+data_dir' => (default => File::Spec->catdir(File::Spec->curdir(), "t", "data"));
has '+xslt_transform_basename' => (default => 'fiction-xml-to-html.xslt');
has '+rng_schema_basename' => (default => 'fiction-xml.rng');

package main;

use lib "./t/lib";

use Test::XML::Ordered qw(is_xml_ordered);

use File::Temp qw(tempfile);

sub _utf8_slurp
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

# TEST:$c=0;
sub test_file
{
    my $args = shift;

    my $input_fn = $args->{input_fn};
    my $output_fn = $args->{output_fn};

    my $xslt = MyGrammar::XSLT->new();

    {
        my $final_source = $xslt->perform_xslt_translation(
            {
                source => {file => $input_fn, },
                output => "string",
            }
        );

        my $xml_source = _utf8_slurp($output_fn);

        # TEST:$c++;
        is_xml_ordered(
            [ string => $final_source, ],
            [ string => $xml_source, ],
            "'$input_fn' generated good output on source/input_filename - output - string"
        );
    }

    {
        my $final_source = $xslt->perform_xslt_translation(
            {
                source => {string_ref => \(_utf8_slurp($input_fn)) },
                output => "string",
            }
        );

        my $xml_source = _utf8_slurp($output_fn);

        # TEST:$c++;
        is_xml_ordered(
            [ string => $final_source, ],
            [ string => $xml_source, ],
            "'$input_fn' generated good output on source/string_ref - output - string"
        );
    }

    {
        my $final_dom = $xslt->perform_xslt_translation(
            {
                source => {string_ref => \(_utf8_slurp($input_fn)) },
                output => "dom",
            }
        );

        my $xml_source = _utf8_slurp($output_fn);

        # TEST:$c++;
        is_xml_ordered(
            [ string => $final_dom->toString(), ],
            [ string => $xml_source, ],
            "'$input_fn' generated good output on source/string_ref - output - dom"
        );
    }

    {
        my ($fh, $filename) = tempfile();

        $xslt->perform_xslt_translation(
            {
                source => {string_ref => \(_utf8_slurp($input_fn)) },
                output => {file => $filename, },
            }
        );

        my $xml_source = _utf8_slurp($output_fn);
        my $final_source = _utf8_slurp($filename);

        # TEST:$c++;
        is_xml_ordered(
            [ string => $final_source, ],
            [ string => $xml_source, ],
            "'$input_fn' generated good output on source/string_ref - output/file"
        );
    }

    {
        my ($fh, $filename) = tempfile();

        $xslt->perform_xslt_translation(
            {
                source => {string_ref => \(_utf8_slurp($input_fn)) },
                output => {fh => $fh, },
            }
        );

        close($fh);

        my $xml_source = _utf8_slurp($output_fn);
        my $final_source = _utf8_slurp($filename);

        # TEST:$c++;
        is_xml_ordered(
            [ string => $final_source, ],
            [ string => $xml_source, ],
            "'$input_fn' generated good output on source/string_ref - output/fh"
        );
    }
    return;
}

# TEST:$test_file=$c;

# TEST*$test_file
test_file(
    {
        input_fn => File::Spec->catfile(
            File::Spec->curdir(), "t", "data", "fiction-xml-test.xml",
        ),
        output_fn => File::Spec->catfile(
            File::Spec->curdir(), "t", "data", "fiction-xml-test-html-xslt-output.xhtml",
        ),
    }
);
