package XML::GrammarBase;

use warnings;
use strict;

use 5.008;

1;

__END__

=head1 NAME

XML::GrammarBase - Provide roles and base classes for processors of
specialized XML grammars.

=head1 SYNOPSIS

See the ones under the Role packages.

=head1 DESCRIPTION

XML::GrammarBase aims to be a convenient framework for easily providing
processors for XML grammars (such as those under the XML::Grammar namespace
- L<http://www.shlomifish.org/open-source/projects/XML-Grammar/> ).

It provides roles and base classes for facilitating writing those.

=head1 SEE ALSO

L<XML::GrammarBase::Role::RelaxNG> , L<XML::GrammarBase::Role::XSLT> .

=head1 FUNCTIONS

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
