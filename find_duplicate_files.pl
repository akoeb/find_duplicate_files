#!/usr/bin/perl
# search directory structure recursively for duplicate files
# duplication is defined by same md5sum, not same file name
# License: GPL3, see COPYING
use strict;
use warnings;

my %CHECKSUMS;

# where to start searching
my @dirs;
while($ARGV[0]) {
    if(-e $ARGV[0] && -d $ARGV[0]) {
        my $dir = shift;
        push @dirs, $dir;

    }
    else {
        die "Argument $ARGV[0] is not a directory or does not exist!\n";
    }
}

foreach my $dir (@dirs) {
    find($dir);
}

##################################################################

sub find {
    my ($topdir) = @_;
    if (substr($topdir, 1, -1) ne '/') {
        $topdir .= '/';
    }

    # read files and subdirectories:
    unless(opendir DIR, $topdir) {
        warn "Cannot open directory $topdir";
        return;
    }

    # get all files and subdirs, including hidden, excluding pointers to same and parent dir
    my @all = map { $topdir . $_ } grep { $_ !~ /^\.+$/ } readdir DIR;
    closedir DIR;

    # recurse into subdirs:
    map { find ($_) } grep { -d } @all;

    # checksum files:
    # TODO: possible optimisation: use other process for checksum calculation
    map { checksum_file($_) } grep { -f } @all;

}



sub checksum_file {
    my ($file) = @_;
    my $checksum = qx{ /usr/bin/md5sum $file | awk '{ print \$1 }' };
    if ($CHECKSUMS{$checksum}) {
        print "Duplication found: $file, $CHECKSUMS{$checksum}\n";
        $CHECKSUMS{$checksum} .= ','.$file;
    }
    else {
        $CHECKSUMS{$checksum} = $file;
    }
}

