package Catmandu::Exporter::PNX;

use Catmandu::Sane;
use Catmandu::Util qw(:is);

our $VERSION = '0.01';

use Moo;
use namespace::clean;

our $PNX_CONTROL_TAGS = [qw(
            sourceid originalsourceid sourcerecordid addsrcrecordid
            recordid sourcetype sourceformat sourcesystem recordtype
            lastmodified)];

our $PNX_DISPLAY_TAGS = [qw(
            availinstitution availlibrary availpnx contributor
            coverage creationdate creator crsinfo description
            edition format identifier ispartof language
            oa publisher relation rights source subject
            title type unititle userrank userreview vertitle)];

our $PNX_LINKS_TAGS = [qw(additionallinks backlink linktoabstract
            linktoextract linktofindingaid linktoholdings
            linktoholdings_avail linktoholdings_unavail
            linktoholdings_notexist linktoprice
            linktorequest linktoreview linktorsrc
            linktotoc linktouc openurl openurlfulltext
            openurlservice thumbnail)];

our $PNX_SEARCH_TAGS = [qw(
            addsrcrecordid addtitle alttitle creationdate creatorcontrib
            crsdept crsid crsinstrc crsname description enddate
            frbrid fulltext general isbn issn matchid orcidid pnxtype
            recordid recordtype ressearscope rsrctype scope searchscope
            sourceid startdate subject syndetics_fulltext syndetics_toc
            title toc usertag
            )];

our $PNX_FACETS_TAGS = [qw(
            classificationlcc classificationddc classificationudc classificationrvk
            collection creationdate creatorcontrib crsdept crsid crsinstrc
            crsname filesize format genre jtitle language library prefilter
            related rsrctype topic toplevel
            )];

our $PNX_SORT_TAGS = [qw(
            author creationdate title
            )];

our $PNX_DEDUP_TAGS = [qw(
            t c1 c2 c3 c4 c5 f1 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11
            )];

our $PNX_FRBR_TAGS = [qw(
            t k1 k2 k3
            )];

our $PNX_DELIVERY_TAGS = [qw(
            delcategory fulltext institution resdelscope
            )];

our $PNX_RANKING_TAGS = [qw(
            booster1 booster2 pcg_type
            )];

our $PNX_ENRICHMENT_TAGS = [qw(
            abstract availability classificationlcc classificationddc classificationudc
            classificationrvk fulltext rankdatefirstcopy ranknocopies ranknoloans
            rankparentchild review toc
            )];

our $PNX_ADDATA_TAGS = [qw(
            abstract addau adddate dat addtitle artnum atitle au aufirst auinit1
            auinit aulast auinitm ausuffix btitle title cop coden aucorp
            co cc date degree advisor doi eissn epage genre inst isbn issn
            issue jtitle format mis1 mis2 mis3 notes objectid oclcid oa
            pages part pmid pub quarter risdate ristype ssn seriesau seriestitle
            stitle sici spage url volume
            )];

our $PNX_BROWSE_TAGS = [qw(
            institution author title subject callnumber
            )];

with 'Catmandu::Exporter';

sub add {
    my ($self, $data) = @_;

    my $id = $data->{_id} // 'undefined';

    if ($self->count == 0) {
        $self->fh->print($self->_oai_header());
    }

    my $deleted = $data->{deleted} ? 1 : 0;

    $self->fh->print($self->_oai_record_header($id, deleted => $deleted));
    $self->fh->print($self->_pnx_header());

    $self->_pnx_tags($data,'control',$PNX_CONTROL_TAGS);

    my @local_lds = map { sprintf "lds%-2.2d" , $_ } (1..50);
    $self->_pnx_tags($data,'display',[@$PNX_DISPLAY_TAGS,@local_lds]);

    my @local_lln = map { sprintf "lln%-2.2d" , $_ } (1..50);
    $self->_pnx_tags($data,'links',[@$PNX_LINKS_TAGS,@local_lln]);

    my @local_lsr = map { sprintf "lsr%-2.2d" , $_ } (1..50);
    $self->_pnx_tags($data,'links',[@$PNX_SEARCH_TAGS,@local_lsr]);

    my @local_lfc = map { sprintf "lfc%-2.2d" , $_ } (1..50);
    $self->_pnx_tags($data,'facets',[@$PNX_FACETS_TAGS,@local_lsr]);

    my @local_lso = map { sprintf "lso%-2.2d" , $_ } (1..50);
    $self->_pnx_tags($data,'sort',[@$PNX_SORT_TAGS,@local_lso]);

    $self->_pnx_tags($data,'dedup',$PNX_DEDUP_TAGS);

    $self->_pnx_tags($data,'frbr',$PNX_FRBR_TAGS);

    $self->_pnx_tags($data,'delivery',$PNX_DELIVERY_TAGS);

    $self->_pnx_tags($data,'ranking',$PNX_RANKING_TAGS);

    my @local_lrn = map { sprintf "lrn%-2.2d" , $_ } (1..50);
    $self->_pnx_tags($data,'enrichment',[@$PNX_ENRICHMENT_TAGS,@local_lrn]);

    my @local_lad = map { sprintf "lrn%-2.2d" , $_ } (1..25);
    $self->_pnx_tags($data,'addata',[@$PNX_ADDATA_TAGS,@local_lad]);

    $self->_pnx_tags($data,'browse',$PNX_BROWSE_TAGS);

    $self->fh->print($self->_pnx_footer());
    $self->fh->print($self->_oai_record_footer());

    1;
}

sub commit {
    my ($self) = @_;

    $self->fh->print(_oai_footer());
}

sub _pnx_tags {
    my ($self,$data,$field,$allowed) = @_;

    my $text = '';

    for my $tag (@$allowed) {
        my $values = $data->{$field}->{$tag};
        next unless defined($values);

        $values = [$values] unless is_array_ref($values);

        for my $val (@$values) {
            $text  .= "<$tag>" . _xml_escape($val) . "</$tag>\n";
        }
    }

    $self->fh->print("<$field>\n$text</$field>\n") if length($text);
}

sub _xml_escape {
    $_ = $_[0];
    s/&/&amp;/sg;
    s/</&lt;/sg;
    s/>/&gt;/sg;
    s/"/&quot;/sg;
    s/'/&apos;/sg;
    $_;
}

sub _pnx_header {
    my $str =<<EOF;
<record>
EOF
}

sub _pnx_footer {
    my $str =<<EOF;
</record>
EOF
}


sub _oai_header {
    my $str =<<EOF;
<?xml version="1.0"  encoding="UTF-8"?>
<OAI-PMH xmlns="http://www.openarchives.org/OAI/2.0/"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="
        http://www.openarchives.org/OAI/2.0/  http://www.openarchives.org/OAI/2.0/OAI-PMH.xsd">
<ListRecords>
EOF
    $str;
}

sub _oai_record_header {
    my ($self,$id,%opts) = @_;

    my $str =<<EOF;
<record>
EOF

    if ($opts{deleted}) {
        $str .= "<header status=\"deleted\">\n";
    }
    else {
        $str .= "<header>\n";
    }

    $str .= <<EOF;
<identifier>$id</identifier>
</header>
<metadata>
EOF
    $str;
}

sub _oai_record_footer {
    my $str =<<EOF;
</metadata>
</record>
EOF
    $str;
}

sub _oai_footer {
    my $str =<<EOF;
</ListRecords>
</OAI-PMH>
EOF
    $str;
}

1;

__END__

=pod

=head1 NAME

Catmandu::Exporter::PNX - an Primo normalized XML (PNX) exporter

=head1 SYNOPSIS

    # From the commandline
    $ catmandu convert JSON --fix myfixes to PNX < /tmp/data.json

    # From Perl

    use Catmandu;

    # Print to STDOUT
    my $exporter = Catmandu-exporter('PNX',fix => 'myfix.txt');

    $exporter->add_many($arrayref);
    $exporter->add_many($iterator);
    $exporter->add_many(sub { });

    $exporter->add($hashref);
    $exporter->commit;

    printf "exported %d objects\n" , $exporter->count;

    # Get an array ref of all records exported
    my $data = $exporter->as_arrayref;

=head1 SEE ALSO

L<Catmandu::Exporter>

=cut
