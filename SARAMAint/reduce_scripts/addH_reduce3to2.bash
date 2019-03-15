#!/bin/bash
# THIS IS THE MASTER SCRIPT TO ADD HYDROGENS TO A PDB FILE by REDUCE v.3 (http://kinemage.biochem.duke.edu/software/reduce.php)
# AND CHANGE THE ADDED HYDROGEN ATOM FORMAT TO MAKE THEM COMPATIBLE TO REDUCE v.2 (http://kinemage.biochem.duke.edu/downloads/software/reduce/)# CP's CAN ONLY BE RUN ON PDB FILES CONSISTANT IN HYDROGEN ATOM FORMAT TO REDUCE v.2
# DOWNLOAD REDUCE HETERO ATOM DICTIONARY LIBRARY FILE FROM http://kinemage.biochem.duke.edu/downloads/software/reduce/reduce_het_dict.txt
# AND KEEP IT IN /home/lib/ TO RUN THE FOLLOWING SCRIPT SUCCESSFULLY (ALTERNATIVELY, CHANGE PATH AND SPECIFY)
# reduce (V.3) SHOULD BE RUNNING UNDER THE COMMAND 'reduce'
# IF YOU HAVE FIXED HYDROGENS WITH REDUCE V.2, SKIP THIS STEP.
# See the examples of the two formats in the files specified below (to be found in this reduce_scripts/ sub-directory)
# REDUCE v.2: reducev2_example.pdb 
# REDUCE v.3: reducev3_example.pdb


pdb=$1

if [ "$#" -lt "1" ]; then
echo  "Enter pdb"
exit
fi

upath=`echo ${0/\/addH_reduce3to2.bash/}`
path=`readlink -f $upath`

$path/trimH.pl $pdb > temp1
reduce -build temp1 -DB ~/lib/reduce_het_dict.txt | awk '$1=="ATOM" || $1=="HETATM"' > temp2
$path/convH_reduce3.pl temp2 > temp3
$path/delcol13.pl temp3 > $pdb
echo "NUMBER OF ATOMS BEFORE ADDING HYDROGENS"
wc -l temp1 | cut -f1 -d' '
echo "NUMBER OF ATOMS AFTER ADDING HYDROGENS"
wc -l $pdb | cut -f1 -d' '

rm temp*

