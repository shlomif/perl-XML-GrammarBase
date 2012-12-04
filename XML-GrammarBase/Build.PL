use strict;
use warnings;

use lib "./inc";

use Test::Run::Builder;

my $builder = Test::Run::Builder->new(
    module_name         => 'XML::GrammarBase',
    license             => 'mit',
    dist_author         => q{Shlomi Fish <shlomif@cpan.org>},
    dist_version_from   => 'lib/XML/GrammarBase.pm',
    requires => {
        'Any::Moose' => 0,
        'File::ShareDir' => 0,
        'XML::LibXML' => '2.0013',
        'XML::LibXSLT' => 0,
        'strict' => 0,
        'warnings' => 0,
    },
    build_requires => {
        'File::Temp' => 0,
        'Test::More' => 0,
    },
    add_to_cleanup      => [ 'XML-GrammarBase-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
