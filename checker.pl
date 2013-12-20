#!/usr/bin/perl 
use strict;
use warnings;


my $logFile = "./life.log";
my $programChecked = "program.pl";
my $logTime;


my $PID;


while(1)
	{

		open (my $LOG,"<" ,$logFile) || die "Failed to open $logFile: $!\n";
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
				# check PID and kill it
				$PID = `pgrep $programChecked`;
				print "$programChecked PID is $PID, doesn't work, will kill it\n";

				if ($PID)
					{
						kill $PID;
						print "$programChecked killed\n";
					}					
		
				my $fork = fork();
				if( $fork == 0 )
					{
   						print "This is child process\n";
   						system("./program.pl");
   						exit 0;
					}
			}
		$logTime = "";
		sleep(10);
	}
