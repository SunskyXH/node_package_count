#!/usr/bin/perl
# use strict;
use warnings;
use autodie;
use JSON;
use utf8;

binmode STDOUT, ":utf8";
print "Path to your package.json: (default to '~/*/package.json')\n";
my $dir = <STDIN>;
chomp($dir);
if(!$dir) {
    $dir = "~/*/package.json";
}
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
            $count{$_} = (exists($count{$_}) ? $count{$_} + 1 : 1);
        }
    }
}

format COUNT =
@< @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<               |@<     |
$index, $name, $count
---------------------------------------------------------------|-------|
.

format COUNT_TOP =
---------------------------------------------------------------|-------|
Node Package Name (page:@<,@<</page)                           |Account|
$%, $=/2 -2
---------------------------------------------------------------|-------|
.
select(STDOUT);
$~ = COUNT;
$^ = COUNT_TOP;
$= = 204; #(page_line_count + 2)* 2

my $counter = 1;
foreach (sort { $count{$b} <=> $count{$a} } keys %count) {
    $index = $counter++;
    $name = $_;
    $count = $count{$_};
    write;
}