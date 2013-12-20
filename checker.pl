#!/usr/bin/perl 
use strict;
use warnings;


my $file = "./life.log";
my $logTime;

while(1)
	{

		open (my $LOG,"<" ,$file) || die "Failed to open $file: $!\n";
		while(<$LOG>)
			{
				$logTime .= $_;
				chomp $logTime;		
			} 
		close ($LOG);

		my $sysTime = time();
		my $timeDiff = $sysTime - $logTime;
                print "LogTime: $logTime\nSysTyme: $sysTime\ntimeDiff: $timeDiff\n\n";
		
		if ($timeDiff > 10)
			{
				print "Checked program does not give a sign of life, most likely crashed, will kill it and start again\n";
				# check PID and kill it
				my $pid = fork();
				if( $pid == 0 )
					{
   						print "This is child process\n";
   						system("./program.pl");
   						exit 0;
					}
			}
		$logTime = "";
		sleep(10);
	}
