#!/bin/csh -f

echo off

set delphip = `delphi_static`

        if ($status == 0)then
        echo
        echo '==========================================================================================================='
        echo 'Delphi is running under the command : delphi_static'
        echo 'Program will run'
        echo '==========================================================================================================='
        echo
        else
        echo
        echo '==========================================================================================================='
        echo 'Delphi is not running under the command : delphi_static'
        echo 'Program will exit'
        echo '==========================================================================================================='
        echo
        goto comment
        endif

if ($#argv == 0) then
comment:
        echo '==========================================================================================================='
        echo "  "
        echo "  "
        echo "  "
        echo "  "
        echo "Missing input file in the command line!"
        echo "  "
        echo "  "
        echo "  "
        echo "SaramaInt:"
        echo "A program to calculate the surface and electrostatic complementarities of interfacial residues buried upon complexation " 
        echo "of two interacting polypeptide chains and plot them in Complementarity Plots"
        echo "  "
        echo "  "
        echo "  "
        echo "usage                      : ./CPinterface.csh -inp  [PDB_filename]"
        echo "example                    : ./CPinterface.csh -inp  1esv.pdb"
        echo "For help                   : ./CPinterface.csh -help "
        echo "  "
        echo "  "
        echo "  "
        echo "The filename can have any number of characters but must not contain any '.' (or space ' ')"
        echo "other than that in the extension '.pdb' (in lowercase);"
        echo "e.g., 1esv.pdb, deca.pdb, 1234.pdb, x1c3.pdb 1abc-wc.pdb 1esv-00001.pdb etc."
        echo " "
        echo "PDB file must not contain more than 990 amino acid residues"
        echo "And only a single polypeptide chain"
        echo "  "
        echo "Atoms must not have multiple occupancies"
        echo "For list of isolated metal ions considered in the calculations (and their appropreate format), view 'DOC/metal.list'"
        echo "  "
        echo "Water coordinates will be trimmed if present in the input pdb file"
        echo "Since water and surface bound ligands are modeled as bulk solvent"
        echo "The pdb file must not contain any ligand/cofactors or else these would also be trimmed prior to the calculations"
        echo "  "
        echo "In case of missing atoms / patches of residues in the input pdb, the (Sm, Em) values may not be authentic!"
        echo "  "
        echo "PDB file should definitely be Hydrogen-fitted by Reduce (v.2)"
        echo "(available at: http://kinemage.biochem.duke.edu/downloads/software/reduce/)"
        echo "Atom and residue types will have to be consistent with brookhaven (PDB) format (see brookhaven.format)"
        echo "Residue (Sequence) Number must not exceed 3 digit (999)"
        echo "Hydrogen atom types provided in the input pdb will have to be consistent with REDUCE, vesrion 2"
        echo "For Molecular visualisation RASMOL should be running and for displaying the plots (postscripts: .ps) ghostview (gv) must be installed"
        echo "  "
        echo "  "
        echo "Main Reference: Self-Complementarity within Proteins: Bridging the Gap between Binding and Folding"
        echo "                         Sankar Basu,  Dhananjay Bhattacharyya, and  Rahul Banerjee*"
        echo "                    Biophysical Journal, Volume 102, Issue 11, June 2012, pp. 2605-2614"
        echo "  "
        echo "  "
        echo "  "
        echo '==========================================================================================================='
        exit

else if ($#argv == 1)then
        set field1 = $argv[1]
        set delim = `echo $field1 | cut -c1`
        echo $delim
        goto pause
else if ($#argv == 2)then
goto start
else if ($#argv > 2)then
        goto comment
        endif
endif

#===================================================================
pause:
        if ($field1 == '-help')then
        cat HELP/help.doc
#       firefox HELP/README.html &
        exit
        else if ($field1 != '-help')then
        goto comment
        endif
#===================================================================
start:
        if ($argv[1] == '-inp')then
        set pdbinp = $argv[2]
        echo
        echo 'Filename you entered:' $pdbinp
        rm -f chfn.inp
        echo $pdbinp > chfn.inp
        set fnch = `./EXEC/chfn.pl`
        echo
        set presence = `ls $pdbinp`
                if ($presence == $pdbinp && $status == 0 && $fnch == 'OK')then
                echo
                echo $pdbinp 'found in the current directory, proceeding'
                echo
                goto proceed
                else
                echo
                echo $pdbinp 'not found in the current directory'
                echo 'or'
                echo 'Incorrect filename (uppercase extension .PDB / presence of more than one dots ".")'
                echo
                exit
                endif
        else if ($argv[1] != '-inp')then
        goto pause
        endif
proceed:
set num = `echo $#argv`
echo $num
        goto run

#============================================================================================================================

run:

echo "  "
echo "  "
echo "  "
echo "SaramaInt:"
echo "A program to calculate the surface and electrostatic complementarities of interfacial residues buried upon complexation " 
echo "of two interacting polypeptide chains and plot them in Complementarity Plots"
echo "  "
echo "  "
echo "  "

echo 'You entered:' $pdbinp
set code = `echo $pdbinp | cut -f1 -d"."`
#echo $code

#=======================================================================
#  CHECK INPUT PDB FORMAT AND OTHER REQUIREMENTS 
#  ACCEPT OR REJECT
#=======================================================================

rm -f formp.pdb
rm -f fch.log
rm -f fpp.status
set errorlog = LOG_`echo $code`
rm -rf $errorlog/

#=======================================================================
# Convert to original Reduce format (e.g., "HG12" -> "2HG1")  if necessary (otherwise skip)
# The 13th column should be either blank or a numeric and never the atom type "H" 
# Rather the 14th column should contain the atom type "H" 
#=======================================================================

./EXEC/reducemap.pl $pdbinp > temp.pdb
mv temp.pdb $pdbinp


#=======================================================================

./EXEC/formcheck.pl $pdbinp > fch.log
set chf = `head -1 formch.out`
        if ($chf == 'stop')then
        echo ""
        echo ""
        echo ""
        echo "===================================================================================================="
        echo "Input pdb file does not satisfy all conditions for the program to run and the program will thus exit"
        echo "===================================================================================================="
        echo ""
        echo ""
        echo ""
        mkdir $errorlog
        cp $pdbinp $errorlog/
        mv fch.log $errorlog/
        echo "==========================================================================================="
        echo "Detailed reasons for incompatibility can be found in the log file: $errorlog/fch.log"
        echo "==========================================================================================="
        echo ""
        echo ""
        echo "==========================================================================================================================="
        echo "Users reporting results using this software, should cite the following articles: (Preferably 1 & 3) "
        echo "==========================================================================================================================="
        echo "1.        Self-Complementarity within Proteins: Bridging the Gap between Binding and Folding"
        echo "                         Sankar Basu,  Dhananjay Bhattacharyya, and  Rahul Banerjee*"
        echo "                              Biophysical Journal, 2012, 102 (11), pp. 2605-2614"
        echo "==========================================================================================================================="
        echo "2. SARAMA: A Standalone Suite of Programs for the Complementarity Plot - A Graphical Structure Validation Tool for Proteins"
        echo "                         Sankar Basu*, Dhananjay Bhattacharyya, and Rahul Banerjee*"
        echo "                  Journal of Bioinformatics and Intelligent Control, 2013, 2 (4) pp. 321-323"
        echo "==========================================================================================================================="
        echo "3.  Applications of the complementarity plot in error detection and structure validation of proteins"
        echo "                         Sankar Basu, Dhananjay Bhattacharyya, and Rahul Banerjee*"
        echo "                    Indian Journal of Biochemistry and Biophysics, 2014, 51 (June) pp. 188-200"
        echo "==========================================================================================================================="
        goto END
        endif

#=======================================================================
#=============== Extract atoms, remove headerlines if any ==============
#=============== HETATM for metals =====================================
#=======================================================================
#=======================================================================

set commls = `head -1 fpp.status`

if ($commls == 'formp.pdb_created')then
goto runcont
else
goto clean
endif

runcont:

awk '$1=="ATOM" || $1=="HETATM"' formp.pdb > temp.pdb
./EXEC/metRrename.csh temp.pdb
mv temp.pdb $pdbinp

#=========================================
# REFRESH DIRECTORY (remove old files if present) 
#=========================================
rm -f alter.inp
rm -f surf_dot
rm -f surf_out
rm -f surf.pdb
rm -f check
rm -f sg.out
rm -f sg.con
rm -f icon.out
rm -f num.out
rm -f remove.out
rm -f inp.pdb
rm -f sphere.dot
rm -f bury.scrt
rm -f bury.out
rm -f sucal1.out
rm -f out.satv
rm -f dsl.out
rm -f dsl.num
rm -f *.log
rm -f *.pot
rm -f *cout.pdb
rm -f *sout.pdb
rm -f inp*
rm -f dsl.num
rm -f dsl.out
rm -f ARCDAT
rm -f core
rm -f ARCDAT
rm -f fort*
rm -f outhiscysO.pdb
rm -f outhisO.pdb
rm -f hiscysNC.pdb
rm -f msph.dot
rm -f numM.res
rm -f met.cores
rm -f fpp.status
rm -f formp.pdb
rm -f formch.out
rm -f redun.out
rm -f res1.out
rm -f temp*
rm -f target.res
rm -f res.replace
rm -f script1.prm
rm -f script2.prm
rm -f chfn.inp
rm -f sres.res
rm -f smres.res
rm -f smresE.res
#=========================================

rm -f redun.out
rm -f rdn.log


cp $pdbinp orig.pdb
set NO = `./EXEC/pdb2resWMchain.pl orig.pdb`
#wc -l orig.res

./EXEC/mapresno1to1.pl $pdbinp > mapped.pdb
./EXEC/metRrename.csh mapped.pdb 
mv mapped.pdb $pdbinp

set chains = `./EXEC/chainsplit.pl $pdbinp`
# Input: inp1.pdb, inp2.pdb
set chain1 = `echo $chains | cut -f1 -d'~'`
set chain2 = `echo $chains | cut -f2 -d'~'`

echo "TWO POLYPEPTIDE CHAINS FOUND IN THE INPUT MOLECULE: CHAIN" \'$chain1\' "AND CHAIN" \'$chain2\'

set code = `echo $pdbinp | cut -f1 -d'.'`
#echo $code

set pdb1 = `echo $code`_`echo $chain1`.pdb
set pdb2 = `echo $code`_`echo $chain2`.pdb
set pdb12 = `echo $code`_`echo $chain1``echo $chain2`.pdb

echo "PDB FILE CONTAINING THE FIRST CHAIN :" $pdb1
echo "PDB FILE CONTAINING THE SECOND CHAIN:" $pdb2
echo "PDB FILE CONTAINING BOTH THE CHAINS :" $pdb12

#=======================================================================================================
#=======================================================================================================
#========= MAP PDB TO AVOID ANY REDUNDANCY OF RESIDUE NUMBERS ==========================================
#=======================================================================================================
#=======================================================================================================
./EXEC/mappdb.pl inp1.pdb inp2.pdb
#=======================================================================================================
#=======================================================================================================
#=======================================================================================================
#=======================================================================================================
#MAP FILE: reso2n.map
#MAPPED PDB1  : inp1map.pdb & CORRESPONDING RESFILE: inp1map.res
#MAPPED PDB2  : inp2map.pdb & CORRESPONDING RESFILE: inp2map.res
#MAPPED PDB12 : inp12map.pdb  & CORRESPONDING RESFILE: inp12map.res
#=======================================================================================================

cp inp1map.pdb $pdb1
cp inp2map.pdb $pdb2
cp inp12map.pdb $pdb12

#===================================================================
# CRAETE OUTPUT DIRECTORY
#===================================================================

set outdir = OUT`echo $code`
rm -rf $outdir/
mkdir $outdir/

#=================================================================
#  MAP PDB FROM RES 1 (ALREADY MAPPED)
#=================================================================
echo "==============================================================="
#./EXEC/mappdb.pl $pdb1 $pdb2 	# internally calls pdb2resWM.pl
#outfile: inp1map.pdb, inp2map.pdb, inp12map.pdb (&.res)

cp $pdb1 inp1map.pdb
set N1 = `./EXEC/pdb2resWMchain.pl inp1map.pdb`
echo "$pdb1 CONTAINS $N1 RESIDUES"
cp $pdb2 inp2map.pdb
set N2 = `./EXEC/pdb2resWMchain.pl inp2map.pdb`
echo "$pdb2 CONTAINS $N2 RESIDUES"
cp $pdb12 inp12map.pdb
set N3 = `./EXEC/pdb2resWMchain.pl inp12map.pdb`
echo "$pdb12 CONTAINS $N3 RESIDUES"

echo "==============================================================="

set lench = `wc -l inp12map.res | cut -f1 -d' '`

echo "==============================================================="
echo "CHECKING CAHIN-LENGTH"
echo "==============================================================="

if ($lench > 990)then
echo "============================================================="
echo "Your PDB file contains "$lench" residues"
echo "Program will exit"
echo "PDB file should contain not more than 990 residues"
echo "============================================================="
exit
else 
echo "============================================================="
echo "Length of the polypeptide chain is $lench (which is OK)"
echo "Program will proceed"
goto PROCEED1
echo "============================================================="
endif

PROCEED1:

#==================redundant residue identities for same position==============
set redn = `cat redun.out`
        if ($redn == 'redundant')then
        echo "=================================================="
        echo 'redundant residue identities for same position(s)'
        set errorlog = LOG_`echo $code`
        rm -rf $errorlog
        mkdir $errorlog
        cat rdn.log
        mv rdn.log $errorlog/
        echo "Look into the " $errorlog/"redn.pdb file and" $errorlog/"rdn.log"
        echo ''
        rm -f redn.pdb
        cp $pdbinp redn.pdb
        mv redn.pdb $errorlog/
        echo 'Program will exit'
        echo ''
        echo "=================================================="
        goto clean
        endif
#================================================
# DETECT METAL COORDINATING RESIDUES
#================================================
#=======================================================================
# SET FIELDS (FILENAMES)
#=======================================================================

echo "==============================================================="
echo "SETTING FIELDS"
echo "==============================================================="

set asa1 = `echo $pdb1 | cut -f1 -d '.'`.asa
set asa2 = `echo $pdb2 | cut -f1 -d '.'`.asa
set asa12 = `echo $pdb12 | cut -f1 -d '.'`.asa
set asa1log = `echo $pdb1 | cut -f1 -d '.'`.asalog
set asa2log = `echo $pdb2 | cut -f1 -d '.'`.asalog
set asa12log = `echo $pdb12 | cut -f1 -d '.'`.asalog
set glbl = `echo $code`.glbl
set dslf = `echo $code`.dsl
set Smfile = `echo $code`.Sm
set Emfile = `echo $code`.Em
set CSplot = `echo $code`.CSplot

set bur12 = `echo $code`.bury
set brst12 = `echo $code`.brst

set surf1 = `echo $pdb1 | cut -f1 -d '.'`-surf.pdb
set surf2 = `echo $pdb2 | cut -f1 -d '.'`-surf.pdb

set intf1 = `echo $pdb1 | cut -f1 -d '.'`-intf.res
set intf2 = `echo $pdb2 | cut -f1 -d '.'`-intf.res

set surf1forsatv = `echo $pdb1 | cut -f1 -d '.'`.surf
set surf2forsatv = `echo $pdb2 | cut -f1 -d '.'`.surf
set surf12forsatv = `echo $pdb12 | cut -f1 -d '.'`.surf

set int1surf = `echo $pdb1 | cut -f1 -d '.'`.isurf
set int2surf = `echo $pdb2 | cut -f1 -d '.'`.isurf

set rasscript = `echo $code`-intsurf.spt
set metcores = `echo $code`.mco
set metrasview = `echo $code`-met.spt
set surf = `echo $code`-surf.pdb

#=========================================================================
#  CALCULATE SOLVENT ACCESSIBLE SURFACE AREA AND DETERMINE THE INTERFACE
#  INTERFACIAL ATOMS SHOULD HAVE DELSAA = (SAA(FREE) - SAA(BOUND)) != 0 
#  GENERATE INTERFACE RES FILES
#=========================================================================

echo "==============================================================="
echo "CALCULATING SOLVENT ACCESSIBLE AREAS AND DETTERMINING INTERFACE"
echo "==============================================================="

rm met.cores
rm met.rasview
./EXEC/mcoord.exe $pdb12
set Nmet = `wc -l met.cores | cut -f1 -d' '`
	if ($Nmet == 0)then
	echo "============================================================"
	echo "============================================================"
	echo "               NO METAL CO-ORDINATION DETECTED"
	echo "============================================================"
	echo "============================================================"
	else
	mv met.cores $metcores
	mv met.rasview $metrasview
	cat $metcores
	rasmol -script $metrasview &
	endif

set rescut = `./EXEC/rescut.pl $pdb12`
#echo $rescut

./EXEC/naccess.bash $pdb1	# A.pdb (original)
./EXEC/naccess.bash $pdb2	# B.pdb (original)
./EXEC/naccess.bash $pdb12	# AB.pdb (original)

set Nint = `./EXEC/delasa.exe $asa1 $asa2 $asa12`
echo "NUMBER OF INTERFACIAL ATOMS BURIED UPON COMPLEXATION:" $Nint

if ($Nint == 0)then
echo "================================================================================================================="
echo "================================================================================================================="
echo "================================================================================================================="
echo "NO INTERFACIAL ATOMS DETECTED. THE CHAINS ARE NON-INTERACTING AS IT SEEMS. HAVE A LOOK AT THE PDB FILE in RASMOL"
echo "$code.pdb: NO INTERFACIAL ATOMS DETECTED. THE CHAINS ARE NON-INTERACTING AS IT SEEMS. HAVE A LOOK AT THE PDB FILE IN RASMOL" > $code.log
echo "================================================================================================================="
echo "================================================================================================================="
echo "================================================================================================================="
mv $code.log $outdir/
mv $pdbinp $outdir/
mv orig.* $outdir/
rm $code*
exit
endif

#outfile: fort.14, fort.15, fort.16

echo "=============================================================="
echo "=============================================================="
cat fort.16
cp fort.16 $code.asaAngsq
echo "=============================================================="
echo "=============================================================="

rm ras*.select

#wc -l inp12map.res
#wc -l orig.res

#./EXEC/crmap.pl
./EXEC/intres.pl
#outfile: intf1.res, intf2.res, ras.select

mv intf1.res $intf1
mv intf2.res $intf2

#=========================================================================
# CALCULATE BURIAL OF RESIDUES AS IN THE WHOLE COMPLEX
#=========================================================================

echo "==============================================================="
echo "CALCULATING BURIAL OF RESIDUES AS IN THE WHOLE (COMPLEX) MOLECULE"
echo "==============================================================="

rm bury.out
rm bury.scrt
./EXEC/buryasa.exe $asa12
ls bury.out reso2n.map
./EXEC/remapbury.pl > $bur12
cp bury.scrt $brst12



#=========================================================================
# GENERATE SURFACE FOR MOLECULE 1 
#=========================================================================

echo "==============================================================="
echo "GENERATING VDW SURFACE FOR MOLECULE 1"
echo "==============================================================="

rm -f alter.inp
rm -f surf_dot
rm -f surf_out
rm -f surf.pdb
rm -f check
rm -f sg.out
rm -f sg.con
rm -f icon.out
rm -f num.out
rm -f remove.out
rm -f inp.pdb
rm -f sphere.dot
rm -f msph.dot

cp inp1map.pdb inp.pdb

./EXEC/dot1.exe
./EXEC/conn4.exe
mv surf.pdb $surf1
./EXEC/msph.exe
./EXEC/alter2m.exe
mv surf_out $surf1forsatv

#=========================================================================
# GENERATE SURFACE FOR MOLECULE 2 
#=========================================================================

echo "==============================================================="
echo "GENERATING VDW SURFACE FOR MOLECULE 2"
echo "==============================================================="

rm -f alter.inp
rm -f surf_dot
rm -f surf_out
rm -f surf.pdb
rm -f check
rm -f sg.out
rm -f sg.con
rm -f icon.out
rm -f num.out
rm -f remove.out
rm -f inp.pdb
rm -f sphere.dot
rm -f msph.dot

cp inp2map.pdb inp.pdb

./EXEC/dot1.exe
./EXEC/conn4.exe
mv surf.pdb $surf2
./EXEC/msph.exe
./EXEC/alter2m.exe
mv surf_out $surf2forsatv

#==================================================================================================
#======================================= SURFACE FILE FOR INTERFACE 1 =============================
#==================================================================================================

./EXEC/isurf.exe $intf1 $surf1forsatv
mv fort.22 $int1surf

#==================================================================================================
#======================================= SURFACE FILE FOR INTERFACE 2 =============================
#==================================================================================================

./EXEC/isurf.exe $intf2 $surf2forsatv
mv fort.22 $int2surf

#==================================================================================================
# GENERATE RASMOL SCRIPT AND DISPLAY INTERFACE
#==================================================================================================

./EXEC/genrasscript.pl $surf1 $surf2

rasmol -script view-surf.spt &
cp view-surf.spt $rasscript

#===================================================================================================
#===================================================================================================
#===================================================================================================
#===================================================================================================
#============= Surface Complementarity calculations ================================================
#===================================================================================================
#===================================================================================================
#===================================================================================================
#===================================================================================================
# CALCULATE SURFACE COMPLEMENTARITY OF INTERFACIAL RESIDUES AGAINST THEIR LOCAL NEIGHBORHOOD
# NEAREST NEIGHBORING DOT SURFACE POINTS COULD BE SAMPLED FROM ANY OF THE INTERFACIAL RESIDUES
# IRRESPECTIVE OF THE TWO POLYPEPTIDE CHAINS TREATING THE ENTIRE INTERFACE AS A SINGLE RIGID BODY 
#==================================================================================================

cat $intf1 $intf2 > intf12.res
cat inp12map.res | wc -l > numM.res
cp inp12map.pdb inp.pdb
ls bury.out
cp $brst12 bury.scrt


#=================================================================
#=================================================================
#=============== WHOLE MOLECULE VDW SURFACE PROVIDED =============
#=================================================================
cat $surf1forsatv $surf2forsatv > surf_out
#=================================================================
#=================================================================
#=================================================================
#=================================================================

echo "==================================================================="
echo "CALCULATING SURFACE COMPLEMENTARITIES (Sm) FOR INTERFACIAL RESIDUES"
echo "==================================================================="

./EXEC/runsatv.pl intf12.res
ls out.satv reso2n.map
./EXEC/remapSm.pl orig.res > $Smfile

./EXEC/mapintpdb.pl 
./EXEC/intmapbury.pl bury.out
#==================================================================================================
# ELECTROSTATIC COMPLEMENTARITY
#==================================================================================================

#=========================================================
# VDW SURFACES OF THE INTERFACIAL RESIDUES (IN PDB FORMAT)
#=========================================================

cat $surf1 $surf2 > inp12map-surf.pdb

./EXEC/mapsurfpdb.pl 

#===========================================================
# SPLIT VDW SURFACES OF INDIVIDUAL RESIDUES AT THE INTERFACE
#===========================================================

echo "==================================================================="
echo "SPLITING SURFACE INTO THAT OF INDIVIDUAL INTERFACIAL RESIDUES"
echo "==================================================================="

./EXEC/spl.exe intf12-surf.pdb intf12.res
set dir = dir`echo $code`
rm -rf $dir
mkdir $dir

mv *s.pdb $dir/

./EXEC/glbN.exe inp12map.pdb bury.out
mv fort.3 $glbl
set gindex = `head -1 $glbl | cut -c1-8`

echo "==================================================================="
echo "GLOBULARITY INDEX:" $gindex
echo "==================================================================="

# calculate disulphide bridges prior to surface generation
# store dsl.out
# precompiled executable (dsl)
# source: dsl.f

echo '   '
echo '================================================'
echo 'Disulphide bridges recognized and remembered :'
echo '================================================'
echo '   '

rm -f dsl.out
rm -f dsl.num
./EXEC/dsl.exe inp12map.pdb
mv dsl.out $dslf

# Modify the pdb file to make compatable with DelPhi
# 1. HIS -> HID/HIE/HIP
# 2. CYS (in disulphide bridges) -> CYX
# 3. blank col. 13 i.e., blank before 3 letter atom codes
# 4. Rename N'terminal & C'terminal residues

echo '   '
echo '==========================================================================='
echo 'RENAMING RESIDUES ACCORDING TO AMBER FORCEFIELD PARAMETERS       '
echo 'You may Look in amber.crg (partial charge) and amber_dummy.siz (vdw radii)'
echo 'Renaming CYS (in disulphide bridges) -> CYX'
echo 'Renaming HIS -> HID/HIE/HIP according to Hydrogens assigned in the pdb file'
echo 'Renaming N-terminal & C-terminal residues'
echo '==========================================================================='
echo '   '

cp $dslf inp.dsl
ls inp12map.res
./EXEC/his2hidep.pl inp12map.pdb # internally calls cys2cyxs.pl
./EXEC/ntrename.pl
cp hiscysNC.pdb inp12map-m.pdb

# Create pdb files of residue patches (all atoms) filled with dummy for the rest of the protein
# Also create the complementary pdb file (the candidate residue being filled up with dummy
# Dummy refers to assigned for vdW radii but unassigned for partial charges
# so that the dielectric boundary is characterized properly but the dummy atoms don't contribute to the electric field

echo ''
echo '==========================================================================================================='
echo 'Generating coordinate files with dummy atoms (assigned only radii with zero charge) to create delphi inputs'
echo 'Details of dummy atom-name listed in amber_dummy.siz and amber.siz'
echo 'Electrostatic Potentials will be calculated twice:'
echo '1. Due to Electric fields generated by the atoms of a selected target residue'
echo '2. Due to Electric fields generated by the atoms of the rest of the chain excluding the selected target residue'
echo 'For both cases, the atoms not contributing to the potential will be treated as dummy atoms'
echo '==========================================================================================================='
echo ''

set Nm = `./EXEC/pdb2resWMchain.pl inp12map-m.pdb`
cp inp12map-m.pdb inp-m.pdb
#======================================================================================
#===================== generate modified res file for the interface ===================
#======================================================================================
./EXEC/genresm.pl
# outfile: intf12-m.res
#======================================================================================
#======================================================================================
./EXEC/genfieldpdb.pl inp12map-m.res intf12-m.res
mv *sf.pdb $dir/
mv *cf.pdb $dir/

#============================ DELETE EXTRA *sf.pdb and *cf.pdb files =======================

#./EXEC/dltexs.bash

#===========================================================================================

mv $dir/$pdb1 .
mv $dir/$pdb2 .
mv $dir/$pdb12 .

echo ''
echo '================================================================================'
echo 'All delphi input coordinate files (padded with dummy atoms) are stored at:' $dir
echo '================================================================================'
echo ''


echo ''
echo '========================================================================='
echo 'delphi_static running: Calculating linearized Poison-Boltzmaan Potentials'
echo 'internal dielectric : 2, external dielectric: 80'
echo 'For other parameters look into script_default.prm'
echo 'To change any parameters modify the appropreate fields in generateprm.pl'
echo 'NOW CALCULATING ELECTROSTATIC COMPLEMENTARITIES OF ALL NON-GLYCINE TARGET RESIDUES'
echo 'Em(all) : from all dot points of the selected target-residue'
echo 'Em(sc)  : from sidechain dot points of the target alone'
echo 'Em(mc)  : from mainchain dot points of the target alone'
echo '========================================================================='
echo ''

echo
echo "==================================================================="
echo "THIS MAY TAKE A WHILE"
echo "You may check the progress by viewing (cat) the ccp.out file"
echo "with residue types temporarily converted to run delphi"
echo "You may find 'NaN' values for exposed or terminal residues which will be taken care off later"
echo "==================================================================="
echo

#======================================================================================
./EXEC/rungenprm.pl intf12-m.res  $dir $gindex bury.out # internally creates script*.prm (by calling generateprm.pl) and runs delphi
#======================================================================================

# also internally calls (corrcoefPspl.f -> ./EXEC/ccps) to compute Preason cross correlation
# Main outfile : ccp.out

./EXEC/renameRT.csh ccp.out
./EXEC/rmgly.pl ccp.out > temp
mv temp ccp.out

cp out.satv $Smfile
cp ccp.out $Emfile

echo "==================================================="
echo "                     Sm           "
echo "==================================================="
cat $Smfile
echo "==================================================="
echo "                     Em           "
echo "==================================================="
cat $Emfile

./EXEC/bdist.exe $Smfile $Emfile
set hydbur = `./EXEC/rGb.exe $bur12`
set cmp1 = `ls fort.512`

        if ($cmp1 == 'fort.512')then
        mv fort.512 $CSplot
        endif

set cb1 = `ls fort.513`
set pb1 = `ls fort.514`
set pe1 = `ls fort.515`

rm -f lod.inp
rm -f flat.inp

set fcb2 = 0
set fpb2 = 0
set fpe2 = 0

        if ($cb1 == 'fort.513')then
        mv fort.513 $code.cb
        cp $code.cb inpp.cb
        ./EXEC/cmp.exe inpp.cb
        mv fort.167 $code-comp.cb
        ./EXEC/tlod.pl
        ./EXEC/treal.exe $code.cb
        mv fort.9 $code.rcb
        set fcb2 = 1
        ./EXEC/conv2.pl cb.inc cb.outc cb.trsq $code.rcb > $code-cb.ps
        endif

        if ($pb1 == 'fort.514')then
        mv fort.514 $code.pb
        cp $code.pb inpp.pb
        ./EXEC/cmp.exe inpp.pb
        mv fort.167 $code-comp.pb
        ./EXEC/tlod.pl
        ./EXEC/treal.exe $code.pb
        mv fort.9 $code.rpb
        set fpb2 = 1
        ./EXEC/conv2.pl pb.inc pb.outc pb.trsq $code.rpb > $code-pb.ps
        endif

        if ($pe1 == 'fort.515')then
        mv fort.515 $code.pe
        cp $code.pe inpp.pe
        ./EXEC/cmp.exe inpp.pe
        mv fort.167 $code-comp.pe
        ./EXEC/tlod.pl
        ./EXEC/treal.exe $code.pe
        mv fort.9 $code.rpe
        set fpe2 = 1
        ./EXEC/conv2.pl pe.inc pe.outc pe.trsq $code.rpe > $code-pe.ps
        endif

        if ($fcb2 == 0 && $fpb2 == 0 && $fpe2 == 0)then
        echo '=========================================================================='
        echo
        echo 'ALL RESIDUES ARE SOLVENT EXPOSED (burial > 0.30) IN THE INPUT PDB:' $pdbinp
	echo 'THUS ONLY ACCESSIBILITY SCORE (rGb) WILL BE CALCULATED'
	echo "CS_l: N/A", "rGb:" $hydbur > $code.CS
        echo '=========================================================================='
        goto clean
        endif

echo ' '
echo '========================================================================'
echo 'STATUS OF THE BURIED / PARTIALLY BURUIED RESIDUES IN THE COMPLEMENTARITY PLOTS'
echo '========================================================================'
echo ' '

        if ($fcb2 == 1)then
        echo '================================================================='
        echo '0.0 <= burial <= 0.05'
        echo '================================================================='
        echo '================================================================='
        cat $code-comp.cb
        echo '================================================================='
        gv $code-cb.ps
        endif

        if ($fpb2 == 1)then
        echo '================================================================='
        echo '0.05 <= burial <= 0.15'
        echo '================================================================='
        cat $code-comp.pb
        echo '================================================================='
        gv $code-pb.ps
        endif

        if ($fpe2 == 1)then
        echo '================================================================='
        echo '0.15 <= burial <= 0.30'
        echo '================================================================='
        cat $code-comp.pe
        echo '================================================================='
        gv $code-pe.ps
        endif

        cat $code-comp.* > $code.cnt
        set count = `./EXEC/fracimp.pl $code.cnt`
        echo "======================="
        ./EXEC/tlod2.exe > $code.lodd   # input : lod.inp
        ./EXEC/calpack.pl $code.Sm > $code.pack
        ./EXEC/calelectro.pl $code.Em > $code.elect
        set CSlod = `cat $code.lodd`
        set Psm = `cat $code.pack`
        set Pem = `cat $code.elect`
        echo
        echo
        echo "========================================================"
        echo "========================================================"
        echo "Average Scores obtained from the benchmark database (DB2):"
        echo "           Standard deviations in parentheses"
        echo "CS_l: 2.24 (+-0.48), rGb: 0.058 (+-0.022)"
        echo "Psm:  -0.855 (+-0.054), Pem: -1.492 (+-0.099)"
        echo "========================================================"
        echo "Thresold values for CS_l: 0.80, rGb: 0.011"
        echo "Count of residues in the Improbable region should be less than 15.0%"
        echo "Structures registering less than threshold values "
        echo "in any of the two (global) scores (CSl, rGb)"
        echo "or the local count (Pcount) needs re-investigation !"
        echo "========================================================"
        echo "========================================================"
        echo "Complementarity Score for the interface:"
        echo "CS_l:" $CSlod
        echo "Accessibility Score for the whole molecule:"
	echo "rGb: " $hydbur
	echo "Score based on Packing alone (Interface):"
        echo "Psm: " $Psm "(should be above -1.017)"
	echo "Score based on Electrostattics alone (Interface):"
        echo "Pem: " $Pem "(should be above -1.789)"
        echo "CS_l:" $CSlod, "rGb:" $hydbur, "Pcount:" $count, "Psm:" $Psm, "Pem:" $Pem > $code.CS
        goto clean
        endif
clean:

rm -rf $dir/
ls surfinp.pdb reso2n.map
./EXEC/remapsurf.pl > $surf
mv surfinp.pdb $outdir/
rm ras1.select
rm ras2.select
rm $code*.lodd
rm $code*.brst
rm $code*.asalog
rm $code*.rsa
rm $code*.isurf
rm $code*.surf
mv $code* $outdir/
mv orig.* $outdir/
./refresh.csh

echo "=========================================================================================================="
echo "OUTPUT DIRECTORY:" $outdir
echo "=========================================================================================================="

rm inp*
rm fort.*
rm int*
rm temp*

echo "==========================================================================================================================="
echo "Users reporting results using this software, should cite the following articles: (Preferably 1 & 3) "
echo "==========================================================================================================================="
echo "1.        Self-Complementarity within Proteins: Bridging the Gap between Binding and Folding"
echo "                         Sankar Basu,  Dhananjay Bhattacharyya, and  Rahul Banerjee*"
echo "                              Biophysical Journal, 2012, 102 (11), pp. 2605-2614"
echo "==========================================================================================================================="
echo "2. SARAMA: A Standalone Suite of Programs for the Complementarity Plot - A Graphical Structure Validation Tool for Proteins"
echo "                         Sankar Basu*, Dhananjay Bhattacharyya, and Rahul Banerjee*"
echo "                  Journal of Bioinformatics and Intelligent Control, 2013, 2 (4) pp. 321-323"
echo "==========================================================================================================================="
echo "3.  Applications of the complementarity plot in error detection and structure validation of proteins"
echo "                         Sankar Basu, Dhananjay Bhattacharyya, and Rahul Banerjee*"
echo "                    Indian Journal of Biochemistry and Biophysics, 2014, 51 (June) pp. 188-200"
echo "==========================================================================================================================="

cat README.output

END:
