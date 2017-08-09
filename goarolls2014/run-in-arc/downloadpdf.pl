#!/usr/bin/perl

if (!-d 'ceogoa.nic.in') {system("mkdir ceogoa.nic.in");}
if (!-d 'ceogoa.nic.in/Voter-List-2014') {system("mkdir ceogoa.nic.in/Voter-List-2014");}

use WWW::Mechanize;
my $ua = WWW::Mechanize->new(agent=>'Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.0.16)',cookie_jar=>{},onerror=>undef);

$ua->get("http://ceogoa.nic.in/PER_Search.aspx");

for ($c=1;$c<=40;$c++) {
    
    print "Download constituency $c\n";
    
    if (!-d 'ceogoa.nic.in/Voter-List-2014/'.$c)  {system("mkdir ceogoa.nic.in/Voter-List-2014/$c");}
    
    my $const = $c;
    
    if ($const <10) {$const="00$const"}
    elsif ($const <100) {$const="0$const"}
    
    for ($no=1;$no<500;$no++) {
	my $part;
	if ($no <10) {$part="00$no"}
	elsif ($no <100) {$part="0$no"}
	else {$part="$no"}
	
	if (!-e "ceogoa.nic.in/Voter-List-2014/$c/$const-$part.pdf") {
	    my $result=$ua->get( "http://ceogoa.nic.in/AC$const/AC".$const."PART".$part.".pdf", ':content_file' => 'ceogoa.nic.in/Voter-List-2014/'.$c.'/'.$const."-".$part.".pdf" );
	    next if $result->code == 404;
	    if ($result->is_error) {
		open (REPORT,">>ceogoa.nic.in/Voter-List-2014/".$c.'/$const.failure');
		print REPORT "Failed to download roll $part: ".$result->status_line."\n";
		close (REPORT);
	    }
	}
        
    }
}
