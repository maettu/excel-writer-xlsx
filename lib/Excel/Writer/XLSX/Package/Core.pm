package Excel::Writer::XLSX::Package::Core;

###############################################################################
#
# Core - A class for writing the Excel XLSX core.xml file.
#
# Used in conjunction with Excel::Writer::XLSX
#
# Copyright 2000-2011, John McNamara, jmcnamara@cpan.org
#
# Documentation after __END__
#

# perltidy with the following options: -mbl=2 -pt=0 -nola

use 5.008002;
use strict;
use warnings;
use Carp;
use Excel::Writer::XLSX::Package::XMLwriter;

our @ISA     = qw(Excel::Writer::XLSX::Package::XMLwriter);
our $VERSION = '0.39';


###############################################################################
#
# Public and private API methods.
#
###############################################################################


###############################################################################
#
# new()
#
# Constructor.
#
sub new {

    my $class = shift;
    my $self  = Excel::Writer::XLSX::Package::XMLwriter->new();

    $self->{_writer}            = undef;
    $self->{_properties}        = {};
    $self->{_localtime}         = [ localtime() ];

    bless $self, $class;

    return $self;
}


###############################################################################
#
# _assemble_xml_file()
#
# Assemble and write the XML file.
#
sub _assemble_xml_file {

    my $self = shift;

    return unless $self->{_writer};

    $self->_write_xml_declaration;
    $self->_write_cp_core_properties();
    $self->_write_dc_title();
    $self->_write_dc_subject();
    $self->_write_dc_creator();
    $self->_write_cp_keywords();
    $self->_write_dc_description();
    $self->_write_cp_last_modified_by();
    $self->_write_dcterms_created();
    $self->_write_dcterms_modified();
    $self->_write_cp_category();
    $self->_write_cp_content_status();

    $self->{_writer}->endTag( 'cp:coreProperties' );

    # Close the XML writer object and filehandle.
    $self->{_writer}->end();
    $self->{_writer}->getOutput()->close();
}


###############################################################################
#
# _set_properties()
#
# Set the document properties.
#
sub _set_properties {

    my $self       = shift;
    my $properties = shift;

    $self->{_properties} = $properties;
}


###############################################################################
#
# Internal methods.
#
###############################################################################


###############################################################################
#
# _localtime_to_iso8601_date()
#
# Convert a localtime() date to a ISO 8601 style "2010-01-01T00:00:00Z" date.
#
sub _localtime_to_iso8601_date {

    my $self = shift;
    my $localtime = shift || $self->{_localtime};

    my ( $seconds, $minutes, $hours, $day, $month, $year ) = @$localtime;

    $month++;
    $year += 1900;

    my $date = sprintf "%4d-%02d-%02dT%02d:%02d:%02dZ", $year, $month, $day,
      $hours, $minutes, $seconds;
}


###############################################################################
#
# XML writing methods.
#
###############################################################################


###############################################################################
#
# _write_cp_core_properties()
#
# Write the <cp:coreProperties> element.
#
sub _write_cp_core_properties {

    my $self = shift;
    my $xmlns_cp =
      'http://schemas.openxmlformats.org/package/2006/metadata/core-properties';
    my $xmlns_dc       = 'http://purl.org/dc/elements/1.1/';
    my $xmlns_dcterms  = 'http://purl.org/dc/terms/';
    my $xmlns_dcmitype = 'http://purl.org/dc/dcmitype/';
    my $xmlns_xsi      = 'http://www.w3.org/2001/XMLSchema-instance';

    my @attributes = (
        'xmlns:cp'       => $xmlns_cp,
        'xmlns:dc'       => $xmlns_dc,
        'xmlns:dcterms'  => $xmlns_dcterms,
        'xmlns:dcmitype' => $xmlns_dcmitype,
        'xmlns:xsi'      => $xmlns_xsi,
    );

    $self->{_writer}->startTag( 'cp:coreProperties', @attributes );
}


###############################################################################
#
# _write_dc_creator()
#
# Write the <dc:creator> element.
#
sub _write_dc_creator {

    my $self = shift;
    my $data = $self->{_properties}->{author} || '';

    $self->{_writer}->dataElement( 'dc:creator', $data );
}


###############################################################################
#
# _write_cp_last_modified_by()
#
# Write the <cp:lastModifiedBy> element.
#
sub _write_cp_last_modified_by {

    my $self = shift;
    my $data = $self->{_properties}->{author} || '';

    $self->{_writer}->dataElement( 'cp:lastModifiedBy', $data );
}


###############################################################################
#
# _write_dcterms_created()
#
# Write the <dcterms:created> element.
#
sub _write_dcterms_created {

    my $self     = shift;
    my $date     = $self->{_properties}->{created};
    my $xsi_type = 'dcterms:W3CDTF';

    $date = $self->_localtime_to_iso8601_date( $date );

    my @attributes = ( 'xsi:type' => $xsi_type, );

    $self->{_writer}->dataElement( 'dcterms:created', $date, @attributes );
}


###############################################################################
#
# _write_dcterms_modified()
#
# Write the <dcterms:modified> element.
#
sub _write_dcterms_modified {

    my $self     = shift;
    my $date     = $self->{_properties}->{created};
    my $xsi_type = 'dcterms:W3CDTF';

    $date =  $self->_localtime_to_iso8601_date( $date );

    my @attributes = ( 'xsi:type' => $xsi_type, );

    $self->{_writer}->dataElement( 'dcterms:modified', $date, @attributes );
}


##############################################################################
#
# _write_dc_title()
#
# Write the <dc:title> element.
#
sub _write_dc_title {

    my $self = shift;
    my $data = $self->{_properties}->{title};

    return unless $data;

    $self->{_writer}->dataElement( 'dc:title', $data );
}


##############################################################################
#
# _write_dc_subject()
#
# Write the <dc:subject> element.
#
sub _write_dc_subject {

    my $self = shift;
    my $data = $self->{_properties}->{subject};

    return unless $data;

    $self->{_writer}->dataElement( 'dc:subject', $data );
}


##############################################################################
#
# _write_cp_keywords()
#
# Write the <cp:keywords> element.
#
sub _write_cp_keywords {

    my $self = shift;
    my $data = $self->{_properties}->{keywords};

    return unless $data;

    $self->{_writer}->dataElement( 'cp:keywords', $data );
}


##############################################################################
#
# _write_dc_description()
#
# Write the <dc:description> element.
#
sub _write_dc_description {

    my $self = shift;
    my $data = $self->{_properties}->{comments};

    return unless $data;

    $self->{_writer}->dataElement( 'dc:description', $data );
}


##############################################################################
#
# _write_cp_category()
#
# Write the <cp:category> element.
#
sub _write_cp_category {

    my $self = shift;
    my $data = $self->{_properties}->{category};

    return unless $data;

    $self->{_writer}->dataElement( 'cp:category', $data );
}


##############################################################################
#
# _write_cp_content_status()
#
# Write the <cp:contentStatus> element.
#
sub _write_cp_content_status {

    my $self = shift;
    my $data = $self->{_properties}->{status};

    return unless $data;

    $self->{_writer}->dataElement( 'cp:contentStatus', $data );
}


1;


__END__

=pod

=head1 NAME

Core - A class for writing the Excel XLSX core.xml file.

=head1 SYNOPSIS

See the documentation for L<Excel::Writer::XLSX>.

=head1 DESCRIPTION

This module is used in conjunction with L<Excel::Writer::XLSX>.

=head1 AUTHOR

John McNamara jmcnamara@cpan.org

=head1 COPYRIGHT

� MM-MMXI, John McNamara.

All Rights Reserved. This module is free software. It may be used, redistributed and/or modified under the same terms as Perl itself.

=head1 LICENSE

Either the Perl Artistic Licence L<http://dev.perl.org/licenses/artistic.html> or the GPL L<http://www.opensource.org/licenses/gpl-license.php>.

=head1 DISCLAIMER OF WARRANTY

See the documentation for L<Excel::Writer::XLSX>.

=cut
