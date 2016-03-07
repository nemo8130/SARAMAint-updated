#!/usr/bin/perl

$pdb1 = $ARGV[0];	# pdb1
chomp $pdb1;

$pdb2 = $ARGV[1];	# pdb2
chomp $pdb2;

open (PDB1,"<$pdb1");
open (PDB2,"<$pdb2");
open (PDB12,">inp12map.pdb");
open (MAP,">reso2n.map");

@atoms1 = <PDB1>;
@atoms2 = <PDB2>;
@atoms12 = (@atoms1,@atoms2);

open (OUTPDB1,">inp1map.pdb");
open (OUTPDB2,">inp2map.pdb");

chomp $atoms1[0];
chomp $atoms2[0];

$ch1 = substr($atoms1[0],21,1);
$ch2 = substr($atoms2[0],21,1);
print "$ch1  $ch2\n";

$resf1 = $pdb1;
$resf1 =~ s/\.pdb/\.res/;

$resf2 = $pdb2;
$resf2 =~ s/\.pdb/\.res/;

`./EXEC/pdb2resWMchain.pl $pdb1`; 
`./EXEC/pdb2resWMchain.pl $pdb2`; 

open (RES1,"<$resf1");
open (RES2,"<$resf2");

@rinp1 = <RES1>;
@rinp2 = <RES2>;

@restog = (@rinp1,@rinp2);

for $a (0..scalar(@restog)-1)
{
chomp $restog[$a];
$rid = substr($restog[$a],4,5);
$ires = substr($restog[$a],0,3);
$res = substr($restog[$a],4,3);
$chain = substr($restog[$a],8,1);
$rn = sprintf("%3d",$a+1);
$rnew = $rn.'-'.$rid;
print MAP "$restog[$a] -> $rnew\n";
#print $rid,"\n";
        foreach $b (@atoms12)
        {
        chomp $b;
        $res1 = substr($b,17,3);
        $chain1 = substr($b,21,1);
        $ires1 = substr($b,23,3);
        $len = length($b)-26;
        $frag1 = substr($b,0,23);
        $frag2 = substr($b,26,$len);
                if ($ires == $ires1 && $res eq $res1 && $chain eq $chain1)
                {
                print PDB12 $frag1,$rn,$frag2,"\n";
			if ($chain eq $ch1)
			{
			print OUTPDB1 $frag1,$rn,$frag2,"\n";
			}
			elsif ($chain eq $ch2)
			{
			print OUTPDB2 $frag1,$rn,$frag2,"\n";
			}
                }
        }
}

`./EXEC/pdb2resWMchain.pl inp12map.pdb`;
`./EXEC/pdb2resWMchain.pl inp1map.pdb`;
`./EXEC/pdb2resWMchain.pl inp2map.pdb`;

print "MAP FILE: reso2n.map\n";
print "MAPPED PDB1  : inp1map.pdb & CORRESPONDING RESFILE: inp1map.res\n";
print "MAPPED PDB2  : inp2map.pdb & CORRESPONDING RESFILE: inp2map.res\n";
print "MAPPED PDB12 : inp12map.pdb  & CORRESPONDING RESFILE: inp12map.res\n";



