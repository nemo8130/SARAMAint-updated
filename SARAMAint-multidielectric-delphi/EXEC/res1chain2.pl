#!/usr/bin/perl
#

$len1=`cut -c9-9 orig.res | sort | uniq -c | head -1`;
chomp $len1;
#print int($len1),"\n";
$len11=$len1+1;
$res1chain2=`head -$len11 orig.res | tail -n 1 | cut -c1-3`;
chomp $res1chain2;
print $res1chain2,"\n";
