# NAME

Catmandu::Exporter::PNX - an Primo normalized XML (PNX) exporter

# SYNOPSIS

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

# SEE ALSO

[Catmandu::Exporter](https://metacpan.org/pod/Catmandu::Exporter)
