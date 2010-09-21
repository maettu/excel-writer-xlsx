###############################################################################
#
# Tests for Excel::Writer::XLSX::Package::Styles methods.
#
# reverse('�'), September 2010, John McNamara, jmcnamara@cpan.org
#

use strict;
use warnings;
use Excel::Writer::XLSX::Package::Styles;
use Excel::Writer::XLSX::Format;
use XML::Writer;

use Test::More tests => 1;

###############################################################################
#
# Tests setup.
#
my $expected;
my $caption;

open my $got_fh, '>', \my $got or die "Failed to open filehandle: $!";

my $obj = Excel::Writer::XLSX::Package::Styles->new();
my $writer = new XML::Writer( OUTPUT => $got_fh );

$obj->{_writer} = $writer;

###############################################################################
#
# Test the _write_xf() method.
#
$caption  = " \tStyles: _write_xf()";
$expected = '<xf numFmtId="0" fontId="0" fillId="0" borderId="0" xfId="0" />';

my $format = Excel::Writer::XLSX::Format->new( 0 );

$obj->_write_xf( $format );

is( $got, $expected, $caption );

__END__


