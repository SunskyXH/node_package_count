#!/usr/bin/perl
# use strict;
use warnings;
use autodie;
use JSON;
use utf8;
use File::Find;
binmode STDOUT, ":utf8";

print "Input workplace absolute path:\n";
my $workplace_path = <STDIN>;
chomp($workplace_path);
my $re1 = '.*?'; # Non-greedy match on filler
my $re2 = '(package\\.json)'; # Fully Qualified Domain Name 1

my $re = $re1.$re2;
my $re3 = '(json)';
my @paths;
sub wanted {
    if ( $File::Find::name =~ m/$re/is && substr($File::Find::name, -4) =~ m/$re3/is) {
        push(@paths, $File::Find::name);
    }
}
find( \&wanted, $workplace_path );

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
|@<< @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<               |@<     |
$index, $name, $count
|----------------------------------------------------------------|-------|
.

format COUNT_TOP =
|----------------------------------------------------------------|-------|
|Node Package Name (TOP100)                                      |Count  |
|----------------------------------------------------------------|-------|
.
select(STDOUT);
$~ = COUNT;
$^ = COUNT_TOP;
$= = 204; #(page_line_count + 2)* 2

my $counter = 1;
foreach (sort { $count{$b} <=> $count{$a} } keys %count) {
    if($counter > 100) {
        last;
    }
    $index = $counter++;
    $name = $_;
    $count = $count{$_};
    write;
}