#!/usr/bin/perl 
use strict;
use warnings;

############################################## checker.pl #######################
#										#
#	Check if program send time stamp to log, if no time stamp, will kill 	#	
#	the program and restart it						#
#	by Robert J. Krasowski							#
#	12/20/2013								#
#										#
#################################################################################


my $timeFile = "./life.log";			# file to store time recorded by program ( should be in RAM)
my $programChecked = "program.pl";		# program that will be checked
my $waitTime = 10;				# time between checks in sec
my $restartLog = "/var/log/watchdog/restart.log";	# log where restart events will be recorded
my $logTime;			
my $PID;


while(1)
	{

		open (my $TIMELOG,"<" ,$timeFile) || die "Failed to open $timeFile: $!\n";
		while(<$TIMELOG>)
			{
				$logTime .= $_;
				chomp $logTime;		
			} 
		close ($TIMELOG);

		my $sysTime = time();
		my $timeDiff = $sysTime - $logTime;	# compare system time with time stamp from log
                print "LogTime: $logTime\nSysTyme: $sysTime\ntimeDiff: $timeDiff\n\n";
		
		if ($timeDiff > $waitTime)
			{
				# check PID and kill it
				$PID = `pgrep $programChecked`;
				print "$programChecked PID is $PID, doesn't work, will kill it\n";
				# put entry into log
				open (my $LOG, ">>" , "$restartLog");
				my $date = `date`;
				chomp $date;
				print $LOG "$date: $programChecked restarted\n";
				close ($LOG);

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
		$PID = "";
		sleep($waitTime+1);
	}
