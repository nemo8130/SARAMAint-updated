#!/bin/csh -f
echo off

chmod +x *.csh
# CLEAN UP ./EXECUTABLE DIRECTORY

if ($#argv != 1)then
# set fort90comp = f95
 echo ' '
 echo '========================================================================='
 echo 'Enter Fortran 90 compiler-name as a commandline argument'
 head -9 USAGE
# echo 'Default compiler: f95'
# echo 'Re-run this executable if the default compiler is not f95 in your system'
 echo '**********************************************************************'
 echo 'You must have PERL (version 5.8 or higher) installed at /usr/bin/perl'
 echo "You also must have delphi installed and running under the command 'delphi_static'"
 echo '**********************************************************************'
 echo '========================================================================='
 echo ' '
 exit
else
 set fort90comp = $argv[1]
 echo ' '
 echo '================================'
 echo 'Your choice of compiler:' $fort90comp
 echo '================================'
 echo ' '
 set chz = `echo $?`
echo $chz
	if ($chz == 0)then
	 echo ' '
	 echo '================================'
         echo 'Compiler found: ' $fort90comp
	 echo '================================'
	 echo ' '
	else
	 echo ' '
	 echo '================================'
	 echo 'Compiler not found in your system:' $fort90comp
	 echo 'Check settings'
	 echo '================================'
	 echo ' '
	endif
endif

set chz = `echo $?`
echo $chz

	if ($chz == 0)then
	 echo ' '
	 echo '================================'
         echo 'Compiler found:' $fort90comp
	 echo '================================'
	 echo ' '
        else
	 echo ' '
	 echo '================================'
         echo 'Compiler not found in your system:' $fort90comp
	 echo 'Check settings'
         exit
	 echo '================================'
	 echo ' '
        endif

echo ' '
echo '================================'
echo 'Ignore Compilation warnings'
echo '================================'
echo ' '

rm -rf ./EXEC/
mkdir ./EXEC/

set totf = `ls ./SRC/*.f | wc -l`

@ cnt = 0

$fort90comp ./SRC/dot1.f -o ./EXEC/dot1.exe
ls ./EXEC/dot1.exe
	if ($? == 0 && $status == 0)then
	@ cnt = $cnt + 1
	endif

$fort90comp ./SRC/metcoord.f -o ./EXEC/mcoord.exe
ls ./EXEC/mcoord.exe
	if ($? == 0 && $status == 0)then
	@ cnt = $cnt + 1
	endif

$fort90comp ./SRC/metsph.f -o ./EXEC/msph.exe
ls ./EXEC/msph.exe
	if ($? == 0 && $status == 0)then
	@ cnt = $cnt + 1
	endif

$fort90comp ./SRC/conn4.f -o ./EXEC/conn4.exe
ls ./EXEC/conn4.exe
	if ($? == 0 && $status == 0)then
	@ cnt = $cnt + 1
	endif

$fort90comp ./SRC/alter2m.f -o ./EXEC/alter2m.exe
ls ./EXEC/alter2m.exe
	if ($? == 0 && $status == 0)then
	@ cnt = $cnt + 1
	endif

$fort90comp ./SRC/satv-package.f -o ./EXEC/satvp.exe
ls ./EXEC/satvp.exe
	if ($? == 0 && $status == 0)then
	@ cnt = $cnt + 1
	endif

$fort90comp ./SRC/dsl.f -o ./EXEC/dsl.exe
ls ./EXEC/dsl.exe
	if ($? == 0 && $status == 0)then
	@ cnt = $cnt + 1
	endif
ls ./SRC/accall.pars
	if ($? == 0)then
	$fort90comp ./SRC/accall.f -o ./EXEC/accall.exe
	ls ./EXEC/accall.exe
		if ($? == 0 && $status == 0)then
		@ cnt = $cnt + 1
		endif
	endif

$fort90comp ./SRC/buryasa.f -o ./EXEC/buryasa.exe
ls ./EXEC/buryasa.exe
	if ($? == 0 && $status == 0)then
	@ cnt = $cnt + 1
	endif

$fort90comp ./SRC/globuleN.f -o ./EXEC/glbN.exe
ls ./EXEC/glbN.exe
	if ($? == 0 && $status == 0)then
	@ cnt = $cnt + 1
	endif

$fort90comp ./SRC/splitsurf.f -o ./EXEC/spl.exe
ls ./EXEC/spl.exe
	if ($? == 0 && $status == 0)then
	@ cnt = $cnt + 1
	endif

$fort90comp ./SRC/corrcoefPsplw.f -o ./EXEC/ccpsw.exe
ls ./EXEC/ccpsw.exe
	if ($? == 0 && $status == 0)then
	@ cnt = $cnt + 1
	endif

$fort90comp ./SRC/delasa.f -o ./EXEC/delasa.exe
ls ./EXEC/delasa.exe
	if ($? == 0 && $status == 0)then
	@ cnt = $cnt + 1
	endif

$fort90comp ./SRC/burdist.f -o ./EXEC/bdist.exe
ls ./EXEC/bdist.exe
	if ($? == 0 && $status == 0)then
	@ cnt = $cnt + 1
	endif

$fort90comp ./SRC/cmpi2.f -o ./EXEC/cmp.exe
ls ./EXEC/cmp.exe
	if ($? == 0 && $status == 0)then
	@ cnt = $cnt + 1
	endif

$fort90comp ./SRC/transreal.f -o ./EXEC/treal.exe
ls ./EXEC/treal.exe
	if ($? == 0 && $status == 0)then
	@ cnt = $cnt + 1
	endif

$fort90comp ./SRC/intf2surf.f -o ./EXEC/isurf.exe
ls ./EXEC/isurf.exe
	if ($? == 0 && $status == 0)then
	@ cnt = $cnt + 1
	endif

$fort90comp ./SRC/tlod2.f -o ./EXEC/tlod2.exe
ls ./EXEC/tlod2.exe
	if ($? == 0 && $status == 0)then
	@ cnt = $cnt + 1
	endif

$fort90comp ./SRC/resGbur.f -o ./EXEC/rGb.exe
ls ./EXEC/rGb.exe
	if ($? == 0 && $status == 0)then
	@ cnt = $cnt + 1
	endif

echo $cnt "OUT OF " $totf

if ($cnt == $totf)then
	echo ' '
	echo '========================================='
	echo 'All ' $totf '(fortran) Compilations successfull'
	echo '========================================='
	echo ' '
else
	echo ' '
	echo '========================================='
	echo 'Compilation failure'
	echo 'Try some other fortran90 compilars'
	echo 'preferred compilers: gfortran, f95, ifort'
	echo '========================================='
	echo ' '
	exit
endif

perl -v
	if ($? == 0 && $status == 0)then
	echo
	echo '========================================='
	echo "PERL found"
	echo '========================================='
	echo
	else
	echo
	echo '========================================='
	echo "PERL not found"
	echo '========================================='
	echo
	exit
	endif

chmod +x ./SRC/*.pl
dos2unix ./SRC/*.pl
dos2unix LIBR/librf.list
chmod +x ./SRC/*.csh
cp ./SRC/*.pl ./EXEC/
cp ./SRC/*.csh ./EXEC/
cp ./SRC/*.bash ./EXEC/
cp refresh.csh ./EXEC/

	foreach i (`cat LIBR/librf.list`)
	dos2unix LIBR/$i
	cp LIBR/$i .
	end

echo ' '
echo '================================================================================='
echo "Ready to run CPinterface.csh"
echo "general usage: './CPinterface.csh inputpdbfile' (input pdb file as a commadline argument)"
echo "input pdb file must have the extension '.pdb' (in LOWERCASE), e.g., 2haq.pdb, 1abc-765.pdb etc"
echo '================================================================================='
echo ' '

tail -12 USAGE

