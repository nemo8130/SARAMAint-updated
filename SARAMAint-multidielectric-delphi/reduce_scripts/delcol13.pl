#!/usr/bin/perl

while (<>)   # 1NO7_A.pdb
{
chomp $_;
print substr($_,0,12),' ',substr($_,13, ),"\n";
}


