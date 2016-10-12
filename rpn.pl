#!/usr/bin/perl
use 5.010;
use strict;
use warnings;
use diagnostics;
use DDP;
BEGIN{
	if ($] < 5.018) {
		package experimental;
		use warnings::register;
	}
}
no warnings 'experimental';
use FindBin;
require "$FindBin::Bin/../lib/tokenize.pl";
	
sub priority
{
	my ($x) = @_;
	if($x =~ /^\+/ || $x =~ /^\-/) {
		return 1;
	}
	elsif($x =~ /\*/ || $x =~ /\// || $x =~ /\%/) {
		return 2;
	}
	elsif($x =~ /U\+/ || $x =~ /U\-/ || $x =~ /\^/) {
		return 4;
	}
	else
	{
		return -1;
	}

}

sub rpn {
	my $expr = shift;
	my $source = tokenize($expr);
	my @stack,my @exit;
	for my $element (@{$source}) {	
		my $sign;
		my $i;
		if ($element=~/\(/) {
			push( @stack,$element);
		}
		elsif ($element=~/\)/) {						
			do {							
				$sign=pop(@stack);
				push(@exit,$sign);	
			}
			until($sign=~/\(/);	
			pop(@exit);
		}
		elsif ($element=~/\d/) {
			push( @exit,$element);
			for(@exit) {
			 chomp($_);						
			}
		}
		elsif ($element=~/(?:(\*)|(\/)|(\^)|(\%)|(\()|(\))|(\-)|(\+)|(U\+)|(U\-))/){									
			$sign=pop(@stack);
			if  (defined $sign) {
				my $pelement =priority($element);											
				my $psign =priority($sign);
				if($pelement <= $psign) {	
					if(($pelement == $psign)&&($pelement ==4)) {
						push(@stack,$sign);					
						push(@stack,$element);
					}						
					else {								
						{
						do {
							push(@exit,$sign);
							$sign=pop(@stack);
							if  (!defined $sign) {
							last;
							}
							$psign = priority($sign);
						}while ($pelement <= $psign);
					}
						push(@stack,$sign);					
						push(@stack,$element);
					}
				}
				else {
					push(@stack,$sign);
					push(@stack,$element);
				}								
			}
			else {
				push(@stack,$element);
			}
		}			

	}


	for my $exitelement (@exit) {
		chomp($exitelement);
	}
	my $l=pop(@stack);
	while (defined  $l) {		
		push(@exit,$l);
		$l=pop(@stack);
	}
	#p @exit;
	return \@exit;
}
1;
