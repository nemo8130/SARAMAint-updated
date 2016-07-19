#!/usr/bin/perl

$fn = $ARGV[0];     # pdb file
chomp $fn;

open (INP,"<$fn");
@dat = <INP>;
close INP;

$resfile = $fn;
$resfile =~ s/\.pdb/\.res/;

open (RES,">$resfile");

@atoms = grep(/^ATOM\s+/,@dat);
@hetatms = grep(/^HETATM\s+/,@dat);

$of = $fn;
$of =~ s/.pdb/.res/g;
open (OUT,">$of");

# EXTRACT CHAIN

foreach $k (@atoms){chomp $k;}
foreach $k (@hetatms){chomp $k;}

$chain1 = substr($atoms[0],21,1);
$chain2 = substr($atoms[scalar(@atoms)-1],21,1);

if ($chain1 eq $chain2)
{
@uchain = ($chain1);
}
elsif ($chain1 ne $chain2)
{
@uchain = ($chain1,$chain2);
}

$l = @uchain;

#printf "%3d\n", $l;

$c = 0;

foreach $chain (@uchain)
{
#print $chain,"\n";
$c++;
$dat = 'dat'.$c;
@$dat = ();
	foreach $at (@atoms)
	{
	chomp $at;
	$chn = substr($at,21,1);
		if ($chain eq $chn)
		{
		@$dat = (@$dat,$at);
		}
	}
}

#print $c,"\n";
$Nres = 0;

@ures = ();

for $i (1..$c)
{
$dat = 'dat'.$i;
$hash = 'hash'.$i;
$udat = 'udat'.$i;
$$hash = ();
	foreach $at (@$dat)
	{
	$r = substr($at,23,3).'-'.substr($at,17,3).'-'.substr($at,21,1);
	$$hash{$r}++;
#	print $r,"\n";
	}
#print "\n\n";
@$udat = sort {$a <=> $b} keys %$hash;
	foreach $u (@$udat)
	{
	printf RES "%9s\n",$u;
	@ures = (@ures,$u);
	$Nres++;
	}
}

# ADD METALS

%hm = ();

foreach $m (@hetatms)
{
chomp $m;
$r = substr($m,23,3).'-'.substr($m,17,3).'-'.substr($m,21,1);
$hm{$r}++;
}

@um = sort {$a<=>$b} keys %hm;

foreach $u (@um)
{
printf RES "%9s\n",$u;
#printf "%9s\n",$u;
$Nres++;
}

print $Nres,"\n";

#printf "%10s  %3d\n",$fn,$l;

#========================= CHECK REDUNDANCY =============================

%redun = ();

foreach $k (@ures)
{
$rn = substr($k,0,3).'-'.substr($k,8,1);
$redun{$rn}++;          # Check redundant residue identities for same position
}

@urn = keys %redun;
@frq = values %redun;

$rrn = 0;
@rdn = ();

for $n (0..scalar(@frq)-1)
{
        if ($frq[$n] > 1)
        {
        $rrn++;
        @rdn = (@rdn,$urn[$n])
        }
}

open (REDUN,">redun.out");

open (LOGR,">rdn.log");

if ($rrn > 0)
{
print LOGR "redundant residue identities for same position found in $rrn cases\n";
print LOGR "for residue position(s):\n";
        foreach $a (@rdn)
        {
        print LOGR "$a\n";
        }
print REDUN "redundant\n";
}



