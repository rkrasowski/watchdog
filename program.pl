#!/usr/bin/perl 
use strict;
use warnings;

print "Starting...\n\n";
my $file = "./life.log";

while (1)
	{

		open (my $LOG,">" ,$file) || die "Failed to open $file: $!\n";
		my $sysTime = time();
		print $LOG "$sysTime\n";
		print "Written to log: $sysTime\n";
		close($LOG);
		sleep(10);
	}
