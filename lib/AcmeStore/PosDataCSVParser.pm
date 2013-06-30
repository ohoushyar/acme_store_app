package AcmeStore::PosDataCSVParser;

use strict;
use warnings;

use Carp;
use Mo qw(build required default);
use FindBin;

use AcmeStore::PosDataParser;

has 'fullpath_filename' => (required => 1);
has 'fh';
has 'no_header' => (default => 0);

sub BUILD {
    my $self = shift;
    open my $fh, '<', $self->{'fullpath_filename'} or croak "Unable to open file handle: ERROR [$!] file [$self->{'fullpath_filename'}]";

    $self->fh($fh);
}

sub save {
    my $self = shift;
    my $header_line = 1 unless !!$self->{'no_header'};
    my $fh = $self->fh;

    while (my $line = <$fh>) {
        if ($header_line) {
            $header_line = 0;
            next;
        }

        eval {
            AcmeStore::PosDataParser->new(line => $line)->save;
        };
        if ($@) {
            carp "Unable to save the line; ERROR [$@]";
        }
    }
}

1;
