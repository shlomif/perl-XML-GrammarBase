package XML::GrammarBase::Role::XSLT::Global;

use strict;
use warnings;


=head1 NAME

XML::GrammarBase::Role::XSLT - a parameterized role for an XSLT converter.

=head1 VERSION

Version 0.0.1

=cut

use Moo::Role;

use MooX 'late';

use XML::LibXML;
use XML::LibXSLT;

use autodie;

our $VERSION = '0.0.1';

with ('XML::GrammarBase::Role::RelaxNG');

has '_xml_parser' => (
    isa => "XML::LibXML",
    is => 'rw',
    default => sub { return XML::LibXML->new; },
    lazy => 1,
);

has '_xslt_parser' => (
    isa => "XML::LibXSLT",
    is => 'rw',
    default => sub { return XML::LibXSLT->new; },
    lazy => 1,
);

=head1 SYNOPSIS

    package XML::Grammar::MyGrammar::RelaxNG::Validate;

    use Moo;

    with ('XML::GrammarBase::Role::XSLT::Global');

=head1 DESCRIPTION

This is a utility global (non-variant) role used by
L<XML::GrammarBase::Role::XSLT> . For internal use.

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

