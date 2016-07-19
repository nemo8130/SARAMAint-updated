#!/usr/bin/perl

# Collects CS_l components

open (OUT,">>lod.inp");

open (INP,"<fort.89");
@dat = <INP>;

foreach $k (@dat)
{
chomp $k;
print OUT $k,"\n";
}
