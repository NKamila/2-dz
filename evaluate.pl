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

sub evaluate {
	my $rpn = shift;
	my @ar=@$rpn;
	#p @ar;
	for (my $i=0; $i<=($#ar); $i++) {
		if ($ar[$i]=~/\D/) {
			if ($ar[$i-1]=~/\-*\d/ && $ar[$i]=~/U-/) {
				$ar[$i]=-$ar[$i-1];
				splice(@ar,$i-1,1);
			 	$i--;
			 }
			elsif ($ar[$i-1]=~/\-*\d/ && $ar[$i]=~/U+/)	{
				$ar[$i]=$ar[$i-1];
				splice(@ar,$i-1,1);
				$i--;
			}				
			elsif ($ar[$i-2]=~/\-*\d+/ && $ar[$i-1]=~/\-*\d+/ && $ar[$i]=~/\+/) {
				$ar[$i]=$ar[$i-1]+$ar[$i-2];
				splice(@ar,$i-2,2);
				#p @ar;
				$i-=2;
			}
			elsif ($ar[$i-2]=~/\-*\d+/ && $ar[$i-1]=~/\-*\d+/ && $ar[$i]=~/\-/) {
				$ar[$i]=$ar[$i-2]-$ar[$i-1];
				splice(@ar,$i-2,2);
				#p @ar;
				$i-=2;
			}
			elsif ($ar[$i-2]=~/\-*\d+/ && $ar[$i-1]=~/\-*\d+/ && $ar[$i]=~/\*/) {
				$ar[$i]=$ar[$i-2]*$ar[$i-1];
				splice(@ar,$i-2,2);
				#p @ar;
				$i-=2;
			}
			elsif ($ar[$i-2]=~/\-*\d+/ && $ar[$i-1]=~/\-*\d+/ && $ar[$i]=~/\//) {
				$ar[$i]=$ar[$i-2]/$ar[$i-1];
				splice(@ar,$i-2,2);
				#p @ar;
				$i-=2;
			}
			elsif ($ar[$i-2]=~/\-*\d+/ && $ar[$i-1]=~/\-*\d+/ && $ar[$i]=~/\^/) {
				$ar[$i]=$ar[$i-2]**$ar[$i-1];
				splice(@ar,$i-2,2);
				#p @ar;
				$i-=2;
			}
			else {
			}
		}
		else {
		}
	}
	#p @ar;
	return ($ar[0]);
}

1;
