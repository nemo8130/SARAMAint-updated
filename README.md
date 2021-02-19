# SARAMAint

A standalone suite of programs to estimate the quality of protein-protein interfaces globally as well as locally. 
SARAMAint plots the distribution of buried amino acid residues at the protein-protein interfaces in the Complementarity Plots (CPint) coupled with the analysis of hydrophobic burial profiles of the same. 


### Please be redirected to access the following CP versions from the below links:
> **SARAMA** (Complementarity Plot for globular proteins): https://github.com/nemo8130/SARAMA-updated
> 
> **CPdock** (Complementarity Plot for protein-protein docking): https://github.com/nemo8130/CPdock


## A more detailed Documentation is available here: 
http://www.saha.ac.in/biop/www/db/local/sarama/sarama-readme.html

Requires PERL (v.5.8 or higher), and a fortran90 compiler (prefered: ifort)
and just one additional package(s) to be pre-installed

1. delphi v.8.3. (http://compbio.clemson.edu/delphi) [executable_name: delphi]

You can either choose to run the single (SARAMA / SARAMAint) or multi-dielctric (SARAMA-multidielctric-delphi / SARAMAint-multidielctric-delphi) version
to appropriately set the protein internal dielectric continumm at the interior / or at the interface.

Users are recomended to read additional background literature before implementing the multi-dielctric Delphi-Gaussian mode here: 
http://www.ncbi.nlm.nih.gov/pmc/articles/PMC3622359/


### Installation

```sh
$ git clone https://github.com/nemo8130/SARAMA-updated
$ cd SARAMA-updated
$ cd SARAMA
$ or
$ cd SARAMA-multidielectric-delphi
$ chmod +x install
$ ./install <fortran90-compiler>  (Default: ifort)
```

```sh
$ git clone https://github.com/nemo8130/SARAMAint-updated
$ cd SARAMAint-updated
$ cd SARAMAint
$ or
$ cd SARAMAint-multidielectric-delphi
$ chmod +x install
$ ./install <fortran90-compiler>  (Default: ifort)
```


## The program has just one mandetory input :

        1. The coordinate (PDB) file for the model

## The other optional input is a specification of a target residue (executes the program on a single residue alone)

        2. -tar NNN-XXX   (e.g., 100-TYR, 67-PHE etc.)

- The specified target residue must map consistant to the residue sequence number of the input PDB file. 
- PDB file MUST contain corrdinates of geometrically fixed Hydrogen atoms 
- preferably fixed by REDUCE v.2 or atleast compatible with the REDUCE format 
  (http://kinemage.biochem.duke.edu/downloads/software/reduce/)


##### Preparatory Step: 

Add Hydrogen atoms

You can generate the fasta sequence by using:
```sh
$ reduce -trim inp.pdb > input.pdb 
$ reduce -build -DB ~/lib/reduce_het_dict.txt <input.pdb> | awk '$1=="ATOM" || $1=="HETATM"'  >  inputH.pdb
```

##### Run Step: 
```sh
$ ./CompPlot -inp <inputH.PDB> 
$ ./CompPlot -inp <inputH.pdb> -tar <45-THR>
$ ./CPint -inp <inputH.pdb>
```
where,
- inputH.pdb: The input pdb (coordinate file in Brrokheaven format; http://www.ccp4.ac.uk/html/procheck_man/manappb.html) file

> EXAMPLE OUTPUT: 
```sh 
$ cat OUT1psr/1psr.CS
```
> 
          CS_l: 1.53895, rGb: 0.06081, Pcount:  8.333, Psm:  -0.844, Pem:  -1.288
> 

### For a detail and exhaustive list and documentation of output features, see: 

>
 SARAMA/README.output
>
 SARAMAint/README.output
>

### Main Reference

      Self-Complementarity within Proteins: Bridging the Gap between Binding and Folding
      Sankar Basu, Dhananjay Bhattacharyya, and Rahul Banerjee*
      Biophysical Journal, 2012, 102 (11) : 2605-2614 
      doi:  http://dx.doi.org/10.1016/j.bpj.2012.04.029

The article is avialable online here: http://www.cell.com/biophysj/abstract/S0006-3495%2812%2900503-6









