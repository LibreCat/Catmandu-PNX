package Catmandu::Importer::PNX;

use Catmandu::Sane;
use Catmandu::Util qw(:is);
use XML::LibXML::Reader;
use Catmandu::PNX;
use feature 'state';

our $VERSION = '0.01';

use Moo;
use namespace::clean;

with 'Catmandu::Importer';

has 'pnx'      => (is => 'lazy');

sub _build_pnx {
    return Catmandu::PNX->new;
}

sub generator {
    my ($self) = @_;

    sub {
        state $reader = XML::LibXML::Reader->new(IO => $self->file);

        my $match = $reader->nextPatternMatch(
            XML::LibXML::Pattern->new(
                '/oai:OAI-PMH/oai:ListRecords//oai:record/oai:metadata/*' ,
                 { oai => 'http://www.openarchives.org/OAI/2.0/' }
            )
        );

        return undef unless $match == 1;

        my $xml = $reader->readOuterXml();

        $xml =~ s{xmlns="[^"]+"}{};
        
        return undef unless length $xml;

        $reader->nextSibling();

        return $self->pnx->parse($xml);
    };
}

1;
