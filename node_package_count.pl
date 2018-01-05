#!/usr/bin/perl
use strict;
use warnings;
use autodie;
use JSON;
use utf8;

binmode STDOUT, ":utf8";

my @paths = (
    ".",
    "./vue-hljs",
);

foreach my $path ( @paths ) {
    my $json;
    {
        local $/; #Enable 'slurp' mode
        open my $fh, "<", $path."/package.json";
        $json = <$fh>;
        close $fh;
    }
    my $data = decode_json($json);
    my @names = keys $data->{'dependencies'};
    foreach my $name ( @names ) {
        print $name . "\n"
    }
}








