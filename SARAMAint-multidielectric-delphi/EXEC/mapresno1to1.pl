#!/usr/bin/perl

$fn = $ARGV[0] || die "Enter pdb filename \n";		# $code.pdb
chomp $fn;
open (INP, "<$fn");
@dat = <INP>;

if (-e "orig.res")
{
$rn2=`./EXEC/res1chain2.pl`;
chomp $rn2;
}
else
{
	die  "orig.res could not be found\n";
}

#print $rn2,"\n";

$chains=`./EXEC/chainsplit.pl $fn`;
chomp $chains;
# Input: inp1.pdb, inp2.pdb
$chain1=`echo $chains | cut -f1 -d'~'`;
chomp $chain1;
$chain2=`echo $chains | cut -f2 -d'~'`;
chomp $chain2;

#print "$chain1 $chain2\n";

open (RES1,">res1.out");

@atoms = grep(/^ATOM\s+/ || /^HETATM\s/,@dat);

$l = @atoms;

$rn1 = int(substr($atoms[0],23,3));

printf RES1 "%3d\n",$rn1;

for $i (0..$l-1)
{
chomp $atoms[$i];
$ch = substr($atoms[$i],21,1);
$fp = substr($atoms[$i],0,22);
$rn = int(substr($atoms[$i],23,3));
$sp = substr($atoms[$i],26, );
	if ($ch eq $chain1)
	{
		$rn = $rn - ($rn1-1);
	}
	elsif ($ch eq $chain2)
	{
		$rn = $rn - ($rn2-1);
	}
printf "%22s%4d%28s\n",$fp,$rn,$sp;
}
