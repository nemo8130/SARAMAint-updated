#!/usr/bin/perl

open (INP1,"<reso2n.map") || die "reso2n.map NOT FOUND\n";
open (INP2,"<surfinp.pdb") || die "surfinp.pdb NOT FOUND\n";

@dat1 = <INP1>;
@dat2 = <INP2>;

@atoms = grep(/^ATOM\s+/,@surf);
$l = @atoms;

for $i (0..$l-1)
{
chomp $atoms[$i];
$fp = substr($atoms[$i],0,16);
$rt = substr($atoms[$i],17,3);
$ch = substr($atoms[$i],21,1);
$rn = int(substr($atoms[$i],23,3));
$sp = substr($atoms[$i],26, );
	foreach $b (@dat1)
	{
	chomp $b;
	$rno = substr($b,0,3);
	$rto = substr($b,4,3);
	$cho = substr($b,8,1);
	$rnn = substr($b,13,3);
	$rtn = substr($b,17,3);
	$chn = substr($b,21,1);
		if ($rn == $rnn && $rt eq $rtn && $ch eq $chn)
		{
		printf "%16s %3s %1s %3d%31s\n",$fp,$rt,$ch,$rn,$sp;
		}	
	}
}


