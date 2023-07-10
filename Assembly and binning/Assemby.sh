metaWRAP install : https://github.com/bxlab/metaWRAP
fq1 = $1
fq2 = $2
assembly outfile = $3
binning outfile = $4

metawrap assembly -1 $1 -2 $2  -o $3 -t 20 -m 2000

metawrap binning --metabat2 -t 20 -m 2000 --run-checkm -a $3/final_assembly.fasta -o $4 $1 $2
