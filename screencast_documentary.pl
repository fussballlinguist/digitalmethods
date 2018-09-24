#!/usr/bin/perl -w

use strict;
use warnings;
use List::MoreUtils qw(uniq);
use Selenium::Remote::Driver;
$| = 1;

###################################################################################
#                                                                                 #
#  A script for the automatic generation of Wikipedia screencast documentaries    #
#  Author: Simon Meier-Vieracker, www.fussballlinguistik.de.                      #
#  Inspired by the Digital Methods Initiative (Amsterdam)                         #
#  Description:                                                                   #
#  - scrapes the URLs of all versions of a Wikipedia page (incl. user pages etc.) #
#  - makes screenshots of a defined number of versions                            #
#  - generates a video from the pictures on request                               #
#  Berlin, September 2018                                                         #
#                                                                                 #
###################################################################################

# Define the wikipedia page you want to screenshot
my $starturl = "https://de.wikipedia.org/wiki/GitHub";

# Define path (a new folder will be created)
my $path = "/Users/Name/Desktop/Screencast/";

# Adjust parameters of the screenshots and the videos in the subroutines at the end of the script

############################
# No changes below this line
############################

my $historyurl;
my $language;
my @urls;
if ($starturl =~ /\/\/(\w+)\.wikipedia\.org/) {
	$language = $1;
}
qx(mkdir $path);
my $starthtml = qx(curl -s '$starturl');
my @startlines = split /<a href=/, $starthtml;
foreach my $startline (@startlines) {
	if ($startline =~ /"(.+?action=history)"/) {
		$historyurl = "https://$language.wikipedia.org" . $1;
		$historyurl =~ s/&amp;/&/;
	}
}
my $counterpage = 1;
my $historyhtml = qx(curl -s '$historyurl');
my @historylines = split /<a href=/, $historyhtml;
print "Going to history…\n";
foreach my $historyline (@historylines) {
	if ($historyline =~ /(\/w\/.+?limit=500&amp;action=history)/) {
		$historyurl = "https://$language.wikipedia.org" . $1;
		$historyurl =~ s/&amp;/&/g;
	}
}
while (defined $historyurl) {
	my $historyhtml = qx(curl -s '$historyurl');
	my @historylines = split /<a href=/, $historyhtml;	
	foreach my $historyline (@historylines) {
		if ($historyline =~ /"(.+?oldid=\d+)"/) {
			my $url = "https://$language.wikipedia.org" . $1;
			$url =~ s/&amp;/&/g;
			unless ($url =~ /diff=/) {
				unshift @urls, $url; # with 'unshift' the URLS will be sorted from oldest to newest, so that the screencast documentary will show the natural chronological development. If you prefer to see the development backwards, change to 'push' and adjust the for-loops in line 97 and 101.
			}
		}
	}
	print "\rGetting versions page no. $counterpage… ";
	undef $historyurl;
	if ($historyhtml =~ /<a href="(\S+offset\S+action=history)" class="mw-nextlink" title=".+?" rel="next">/) {
		$historyurl = "https://$language.wikipedia.org" . $1;
		$historyurl =~ s/&amp;/&/g;
		$counterpage++;
	}
}
print "Complete!\n";
@urls = uniq(@urls);
open OUT, "> $path/urls.txt" or die;
foreach my $url (@urls) {
	print OUT "$url\n";
}
my $counter = scalar @urls;
print "How many versions of a total of $counter do you want to make screenshots of? ";
my $string=<STDIN>;
$counter = 0;
print "Newest (n) or oldest (o)? ";
my $chrono=<STDIN>;
chomp $chrono;
print "Do you want me to generate a video from the pictures (y/n)? ";
my $video=<STDIN>;
chomp $video;
print "Making screenshots… ";
if ($chrono eq "n") {
	for (@urls[-$string..-1]) {
		screenshot();
	}
} else {
	for (@urls[0..$string]) {
		screenshot();
	}
}
print "done!\n";
if ($video eq "y") {
	video();
	print "Done!\n";
}

################

sub screenshot {
	$counter++;
	my $length = length($counter);
	my $difference = 4 - $length;
	my $nr = "0" x $difference . $counter;
	my $filename = "$path$nr.jpg";
	my $driver = Selenium::Remote::Driver->new(browser_name => 'safari'); #change browser if needed
	$driver->get($_);
	$driver->set_window_size(1700, 1200); #adjust size of screenshot if needed
	$driver->capture_screenshot($filename);
}

sub video {
	print "Generating video… ";
	qx(convert -delay 50 -resize 50% $path/*.jpg $path/screencast.gif); #adjust video settings and format if needed
}
