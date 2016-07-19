# SARAMA (& SARAMAint)

>
A standalone suite of programs to plot the distribution of amino acid residues in the Complementarity Plots 
>
for those which are embedded at the protein interior (SARAMA)
> 
[READ more] (http://www.cell.com/biophysj/abstract/S0006-3495%2812%2900503-6)
>
for those that are buried upon complexation, embedded at the Protein-Protein Interfaces (SARAMAint)
>
[READ more] (http://www.ingentaconnect.com/content/asp/jbic/2014/00000003/00000004/art00011?token=004c1abebd13fe84c9383a4b3b25702e7b757a5a6a38572066282a72752d7bdfe8b8aaf4e2f5)
>

## A more detailed Documentation is available here: 
http://www.saha.ac.in/biop/www/db/local/sarama/sarama-readme.html

Requires PERL (v.5.8 or higher), and a fortran90 compiler (prefered: ifort)
and just one additional package(s) to be pre-installed

1. delphi v.6.2 (http://compbio.clemson.edu/delphi/) [executable_name: delphi_static / delphi95]

You can either choose to run the single (SARAMA) or multi-dielctric (SARAMA-multidielctric-delphi) version
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









