use threads;
use threads::shared;
use LWP::Simple;
use URI::URL;
use LWP::UserAgent;
use Parallel::ForkManager;
use HTTP::Request::Common;
use HTTP::Request::Common qw(GET);
use HTTP::Request;
use HTML::TreeBuilder;

$Logo="                                        
 @@@@@@   @@@       @@@@@@@@  @@@  @@@   @@@@@@   
@@@@@@@@  @@@       @@@@@@@@  @@@  @@@  @@@@@@@@  
@@!  @@@  @@!       @@!       @@!  !@@  @@!  @@@  
!@!  @!@  !@!       !@!       !@!  @!!  !@!  @!@  
@!@!@!@!  @!!       @!!!:!     !@@!@!   @!@!@!@!  
!!!@!!!!  !!!       !!!!!:      @!!!    !!!@!!!!  
!!:  !!!  !!:       !!:        !: :!!   !!:  !!!  
:!:  !:!  :!:       :!:       :!:  !:!  :!:  !:!  
::   :::  :: ::::   :: ::::   ::  :::   ::   :::  
 :   : :  : :: : :  : :: ::    :   ::    :   : :                
	          Rank Checker
			  
By MrAbdelaziz
link:https://github.com/MrAbdelaziz/Alexa-Rank-Checker
\n\n";
    
	print $Logo;
	
	print "List Of Domains -> ";
	my $Hosts = <STDIN>;
	chomp($Hosts);
	open (DFILE, "<$Hosts") || die "[-] Can't Found ($Hosts) !";
	my @Hosts = <DFILE>;
	close DFILE;
	
	print "start checking ...\n";
	my $pm = new Parallel::ForkManager(10);
	
	foreach $host (@Hosts)
	{
	  my $pid = $pm->start and next;
	  alexa();
	  $pm->finish;
	}
	
    $pm->wait_all_children();

	sub alexa($host)
	{

		 chomp $host;
		 
		 my $ua = LWP::UserAgent->new(
			ssl_opts => {verify_hostname => 0,}
		  );					
		  
		  $response = $ua->post('https://sitescorechecker.com/alexa-rank-checker/output',{ url => $host , submit => "Submit"});
		  
			my $t = HTML::TreeBuilder->new_from_content($response->content);
			my ($table) = $t->look_down(_tag => q{table});
			my @rows = $table->look_down(_tag => q{tr});
			print "domain :".$host."\n";
			
			open(SAVE,">>data.txt");
			print SAVE $host."\n";
			close(SAVE);
			
			for my $row (@rows)
			{
				print $row->as_text."\n";
				open(SAVE,">>data.txt");
				print SAVE $row->as_text."\n";
			}
			print SAVE "--------------------------------------\n";
			close(SAVE);
			
			threads->exit();
			next;
	}