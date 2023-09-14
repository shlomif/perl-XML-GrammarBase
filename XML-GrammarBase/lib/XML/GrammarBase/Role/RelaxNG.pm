package XML::GrammarBase::Role::RelaxNG;

use strict;
use warnings;

=head1 NAME

XML::GrammarBase::Role::RelaxNG - base class for a RelaxNG validator

=cut

use MooX::Role 'late';

use File::ShareDir qw(dist_dir);
use XML::LibXML 2.0017;

with('XML::GrammarBase::Role::DataDir');

has 'rng_schema_basename' => ( isa => 'Str', is => 'rw' );
has '_rng' => (
    isa     => 'XML::LibXML::RelaxNG',
    is      => 'rw',
    default => sub { return shift->_calc_default_rng_schema; },
    lazy    => 1,
);

sub _calc_default_rng_schema
{
    my ($self) = @_;

    my $rngschema =
        XML::LibXML::RelaxNG->new(
        location => $self->dist_path_slot('rng_schema_basename'), );

    return $rngschema;
}

sub rng_validate_dom
{
    my ( $self, $source_dom ) = @_;

    my $ret_code;

    eval { $ret_code = $self->_rng()->validate($source_dom); };

    if ( defined($ret_code) && ( $ret_code == 0 ) )
    {
        # It's OK.
    }
    else
    {
        confess "RelaxNG validation failed [\$ret_code == "
            . $self->_undefize($ret_code)
            . " ; $@]";
    }

    return;
}

sub _calc_parser
{
    my ($self) = @_;

    my $xml_parser = XML::LibXML->new();

    $xml_parser->validation(0);
    $xml_parser->load_ext_dtd(0);
    $xml_parser->no_network(1);

    return $xml_parser;
}

sub rng_validate_file
{
    my ( $self, $filename ) = @_;

    my $dom = $self->_calc_parser()->parse_file($filename);

    return $self->rng_validate_dom($dom);
}

sub rng_validate_string
{
    my ( $self, $xml_string ) = @_;

    my $dom = $self->_calc_parser()->parse_string($xml_string);

    return $self->rng_validate_dom($dom);
}

1;

__END__

=head1 SYNOPSIS

    package XML::Grammar::MyGrammar::RelaxNG::Validate;

    use MooX 'late';

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

=head2 $self->dist_path($basename)

Returns the $basename relative to data_dir().

Utility method.

=head2 $self->dist_path_slot($slot)

Returns the basename of $self->$slot() relative to data_dir().

Utility method.

=head2 BUILD

L<Any::Moose> constructor. For internal use.

=head1 AUTHOR

Shlomi Fish, C<< <shlomif at cpan.org> >>



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
