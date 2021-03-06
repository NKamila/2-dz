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

sub tokenize {
	chomp(my $expr = shift);
	my @res;
	my $k=0;
	my $j=0;
	if ($expr=~/[+-][\/\*]/) {
		die "binary operator can not go after unary";
	}
		
	if ($expr=~/[\/\*\(][\/\*]/) {
		die "two binary sign standing next each other";
	}
	if ($expr=~/[a-df-zA-DF-Z]/) {
		die "wrong"; 
	}
	if ($expr=~/(\d+)\.(\d+)\.(\d+)/) {
		die "wrong";
	}
	if ($expr=~/(ee+)/) {
		die "wrong";
	}
	if ($expr=~/[\(\+\-\*\/\^\(e]$/) {
		die "wrong";
	}
	if ($expr=~/[\!\@\#\$\%\&\_]/) {
		die "wrong";
	}
	if ($expr=~/^[\/\*\^]/)
	{
		die "wrong";
	}
	if ($expr=~/[\-\+\/\*\^]\)/)
	{
		die "wrong";
	}
	if ($expr=~/\d+[ ]\d+/) {
		die "wrong";
	}

	$expr=~s/[ ]+//g;
	$expr=~s/(\D|^)(\.\d*)/$1.$k.$2/ge;
	#$expr=~ s/([\d+])(\.[\d+])/$1.$2/g;
 	#$expr=~s/(\d+)\^(\d+)/$1**$2/ge;
	$expr=~s/([\+\-\/\*\(\^]|^)([\+\-])/$1U$2/g;
	$expr=~s/(\d+)\.$k/$1/g;
	$expr=~s/(\d*\.*\d*)e(.?\d+)/$1*10**$2;/ge;	
	# #$expr=~s/(\D)([+-])/$1U$2/g;
	$expr=~ s/^([\+\-])/U$1/g;
	$expr=~s/([\*\/])([\+\-][\(])/$1U$2/g;
	$expr=~s/([\+\-])([\+\-][\d])/$1U$2/g;
	@res=split /(?:(\*)|(\/)|(\^)|(\()|(\))|(\-)|(\+)|(U\+)|(U\-))/,$expr;
	#p (@res);
	for(my $i = 0;$i <= $#res;$i++) {	
		if (!defined($res[$i])) {
			splice(@res,$i,1);
			$i--;
		}
		elsif(($res[$i])=~/^\s*$/) {
			splice(@res,$i,1);
			$i--;
		}
		else {
		}
	}
	# for(my $i = 0;$i <=$#res;$i++) {
	# if ($res[$i]=~/(\*)|(\/)|(\^)|(\-)|(\+)|(U\+)|(U\-)/){
	# 	$j++;

	# }
	# else {
	# 	$j+=0;
	# }

	# }
	# if ($j==0){
	# 	die "wrong";
	# }
	#p (@res);
	return \@res;
}
1;
