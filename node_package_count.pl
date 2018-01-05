#!/usr/bin/perl
use strict;
use warnings;
use autodie;
use JSON;
use utf8;

binmode STDOUT, ":utf8";

my $dir = "~/*/package.json";
my @paths = glob( $dir );
my %count;
foreach my $path ( @paths ) {
    my $json;
    {
        local $/; #Enable 'slurp' mode
        open my $fh, "<", $path;
        $json = <$fh>;
        close $fh;
    }
    my $data = decode_json($json);
    if(exists($data->{'dependencies'})){
        foreach ( keys $data->{'dependencies'} ) {
            ( exists($count{$_}) ) ? $count{$_} += 1 : $count{$_} = 1 ;
        }
    }
}
foreach (keys %count) {
    print $_ . ":" . $count{$_} . "\n";
}









