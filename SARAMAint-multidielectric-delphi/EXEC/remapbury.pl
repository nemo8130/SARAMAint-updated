#!/usr/bin/perl

open (INP1,"<reso2n.map") || die "reso2n.map NOT FOUND\n";
open (INP2,"<bury.out") || die "bury.out NOT FOUND\n";

@dat1 = <INP1>;
@dat2 = <INP2>;

foreach $k (@dat2)
{
chomp $k;
$rn = substr($k,7,3);
$rt = substr($k,15,3);
$rest = substr($k,10,36);
$ch = substr($k,19,1);
	foreach $b (@dat1)
	{
	chomp $b;
	$rno = substr($b,0,3);
	$rto = substr($b,4,3);
	$cho = substr($b,8,1);
	$rnn = substr($b,13,3);
	$rtn = substr($b,17,3);
	$chn = substr($b,21,1);
	$nstr = $rno.' '.$rto.' '.$cho;
		if ($rn == $rnn && $rt eq $rtn && $ch eq $chn)
		{
		printf "%7s%3d%36s\n",'       ',$nstr,$rest,$cho;
		}	
	}
}


