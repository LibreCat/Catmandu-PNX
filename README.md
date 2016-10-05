# NAME

Catmandu::PNX - Modules for handling PNX data within the Catmandu framework

# SYNOPSIS

Command line client `catmandu`:

    catmandu convert PNX to JSON --fix myfixes.txt < data/pnx.xml > data/pnx.json

    catmandu convert JSON to PNX --fix myfixes.txt < data/pnx.json > data/pnx.xml

See documentation of modules for more examples.

# DESCRIPTION

Catmandu::PNX contains modules to handle PNX an
XML Schema for Ex Libris' Primo search engine.

# AVAILABLE MODULES

- [Catmandu::Exporter::PNX](https://metacpan.org/pod/Catmandu::Exporter::PNX)

    Serialize PNX data

- [Catmandu::Importer::PNX](https://metacpan.org/pod/Catmandu::Importer::PNX)

    Parse PNX data

# SEE ALSO

This module is based on the [Catmandu](https://metacpan.org/pod/Catmandu) framework and [XML::Compile](https://metacpan.org/pod/XML::Compile).
For more information on Catmandu visit: http://librecat.org/Catmandu/
or follow the blog posts at: https://librecatproject.wordpress.com/

# COPYRIGHT AND LICENSE

Patrick Hochstenbach, 2016 -

This is free software; you can redistribute it and/or modify it under the same
terms as the Perl 5 programming language system itself.
