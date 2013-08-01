#!/usr/bin/perl -w

# Script will parse a weather data file data file and output the day on which the min
# temperature spread occurred.
#
# sample data:
#  Dy MxT   MnT   AvT   HDDay  AvDP 1HrP TPcpn WxType PDir AvSp Dir MxS SkyC MxR MnR AvSLP
#   1  88    59    74          53.8       0.00 F       280  9.6 270  17  1.6  93 23 1004.5
use strict;

sub usage {
  # prints usage
  print "Usage: $0 <input file>\n";
  print "Input file should contain data like this:\n";
  print "1  88    59    74   ....\n";
  die "Exiting...\n";
}


####################################################
####################################################
####################################################

# Check args and input
my $inputFile;
if ($ARGV[0]) {
  $inputFile = $ARGV[0];
} else {
  &usage;
}

if ( ! -e $inputFile ) {
  die "Input file: $inputFile does not exist!\n";
} elsif ( -z $inputFile ) {
  die "Input file: $inputFile is empty!\n";
}

# Open file for reading
open (my $inputFh, "<", $inputFile)
  or die "cannot open < $inputFile: $!";

my $minSpread;    # current min temp spread for dataset
my $minSpreadDay; # current day on which min spread occurs

# Main loop
while (<$inputFh>) {
  # skip lines that are not daily data
  unless (/^\s*\d+\s+\d+\s+/) {
    next;
  }
  # strip leading whitespace
  $_ =~ s/^\s*//;
  my @elements = split /\s+/;
  my $day = $elements[0];
  my $minTemp = $elements[2];
  my $maxTemp = $elements[1];
  $minTemp =~ s/\D//g;
  $maxTemp =~ s/\D//g;
  my $spread = $maxTemp - $minTemp;
  if ( ! $minSpread ) {
    # initialize
    $minSpread = $spread;
    $minSpreadDay = $day;
    next;
  }
  if ( $spread < $minSpread ) {
    $minSpread = $spread;
    $minSpreadDay = $day;
  }
}

print "min spread = $minSpread on day $minSpreadDay\n";

# cleanup
close $inputFh;
