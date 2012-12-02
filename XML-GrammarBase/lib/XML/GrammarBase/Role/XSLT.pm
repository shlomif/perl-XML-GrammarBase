package XML::GrammarBase::Role::XSLT;

use strict;
use warnings;


=head1 NAME

XML::GrammarBase::Role::XSLT - role for an XSLT converter.

=head1 VERSION

Version 0.0.1

=cut

use Any::Moose 'Role';

use XML::LibXML;
use XML::LibXSLT;

our $VERSION = '0.0.1';

with ('XML::GrammarBase::Role::RelaxNG');

has 'xslt_transform_basename' => (isa => 'Str', is => 'rw');
has '_stylesheet' => (isa => "XML::LibXSLT::StylesheetWrapper", is => 'rw');
has '_xml_parser' => (isa => "XML::LibXML", is => 'rw');

sub BUILD {}

after 'BUILD' => sub {
    my ($self) = @_;

    my $data_dir = $self->data_dir() ||
        dist_dir( $self->module_base() );

    $self->data_dir($data_dir);

    $self->_xml_parser(XML::LibXML->new());

    my $xslt = XML::LibXSLT->new();

    my $style_doc = $self->_xml_parser()->parse_file(
        File::Spec->catfile(
            $self->data_dir(),
            $self->xslt_transform_basename(),
        ),
    );

    $self->_stylesheet($xslt->parse_stylesheet($style_doc));

    return;
};

sub _undefize
{
    my $v = shift;

    return defined($v) ? $v : "(undef)";
}

sub _calc_and_ret_dom_without_validate
{
    my $self = shift;
    my $args = shift;

    my $source = $args->{source};

    return
          exists($source->{'dom'})
        ? $source->{'dom'}
        : exists($source->{'string_ref'})
        ? $self->_xml_parser()->parse_string(${$source->{'string_ref'}})
        : $self->_xml_parser()->parse_file($source->{'file'})
        ;
}

sub _get_dom_from_source
{
    my $self = shift;
    my $args = shift;

    my $source_dom = $self->_calc_and_ret_dom_without_validate($args);

    my $ret_code;

    eval
    {
        $ret_code = $self->_rng()->validate($source_dom);
    };

    if (defined($ret_code) && ($ret_code == 0))
    {
        # It's OK.
    }
    else
    {
        confess "RelaxNG validation failed [\$ret_code == "
            . _undefize($ret_code) . " ; $@]"
            ;
    }

    return $source_dom;
}

sub perform_xslt_translation
{
    my ($self, $args) = @_;

    my $source_dom = $self->_get_dom_from_source($args);

    my $stylesheet = $self->_stylesheet();

    my $results = $stylesheet->transform($source_dom);

    my $medium = $args->{output};

    if ($medium eq "string")
    {
        return $stylesheet->output_string($results);
    }
    elsif ($medium eq "dom")
    {
        return $results;
    }
    else
    {
        confess "Unknown medium";
    }
}

=head1 SYNOPSIS

    package XML::Grammar::MyGrammar::RelaxNG::Validate;

    use Any::Moose;

    with ('XML::GrammarBase::Role::RelaxNG');

    has '+module_base' => (default => 'XML::Grammar::MyGrammar');
    has '+rng_schema_basename' => (default => 'my-grammar.rng');

    package main;

    my $rnger = XML::Grammar::MyGrammar::RelaxNG::Validate->new(
        data_dir => "/path/to/data-dir",
    );

    # Throws an exception on failure.
    $rnger->rng_validate_file("/different-path-to-xml-file.xml");

=head1 SLOTS

=head2 module_base

The basename of the module - used for dist dir.

=head2 data_dir

The data directory where the XML assets can be found (the RELAX NG schema, etc.)

=head2 rng_schema_basename

The Relax NG Schema basename.

=head1 METHODS

=head2 $self->rng_validate_dom($source_dom)

Validates the DOM ( $source_dom ) using the RELAX-NG schema.

=head2 $self->rng_validate_file($file_path)

Validates the file in $file_path using the RELAX-NG schema.

=head2 $self->rng_validate_string($xml_string)

Validates the XML in the $xml_string using the RELAX-NG schema.

=head2 $converter->perform_xslt_translation

=over 4

=item * my $final_source = $converter->perform_xslt_translation({source => {file => $filename}, output => "string" })

=item * my $final_source = $converter->perform_xslt_translation({source => {string_ref => \$buffer}, output => "string" })

=item * my $final_dom = $converter->perform_xslt_translation({source => {file => $filename}, output => "dom" })

=item * my $final_dom = $converter->perform_xslt_translation({source => {dom => $libxml_dom}, output => "dom" })

=back

Does the actual conversion. The C<'source'> argument points to a hash-ref with
keys and values for the source. If C<'file'> is specified there it points to the
filename to translate (currently the only available source). If
C<'string_ref'> is specified it points to a reference to a string, with the
contents of the source XML. If C<'dom'> is specified then it points to an XML
DOM as parsed or constructed by XML::LibXML.

The C<'output'> key specifies the return value. A value of C<'string'> returns
the XML as a string, and a value of C<'dom'> returns the XML as an
L<XML::LibXML> DOM object.

=cut

=head2 BUILD

L<Any::Moose> constructor. For internal use.

=head1 AUTHOR

Shlomi Fish, C<< <shlomif at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-xml-grammarbase at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=XML-GrammarBase>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc XML::GrammarBase

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=XML-GrammarBase>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/XML-GrammarBase>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/XML-GrammarBase>

=item * Search CPAN

L<http://search.cpan.org/dist/XML-GrammarBase/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2009 Shlomi Fish.

This program is distributed under the MIT (X11) License:
L<http://www.opensource.org/licenses/mit-license.php>

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

=cut

1; # End of XML::GrammarBase::RelaxNG::Validate
