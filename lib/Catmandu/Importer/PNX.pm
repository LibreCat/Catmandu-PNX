package Catmandu::Importer::PNX;

use Catmandu::Sane;
use Catmandu::Util qw(:is);
use XML::LibXML::Reader;
use feature 'state';

our $VERSION = '0.01';

use Moo;
use namespace::clean;

with 'Catmandu::Importer';

sub generator {
    my ($self) = @_;

    sub {
        state $reader = XML::LibXML::Reader->new(IO => $self->file);

        my $match = $reader->nextPatternMatch(
            XML::LibXML::Pattern->new(
                '/oai:OAI-PMH/oai:ListRecords//oai:record' ,
                 { oai => 'http://www.openarchives.org/OAI/2.0/' }
            )
        );

        return undef unless $match == 1;

        my $xml = $reader->readOuterXml();

        return undef unless length $xml;

        $reader->nextSibling();

        return +{ xml => $xml };
    };
}

1;
