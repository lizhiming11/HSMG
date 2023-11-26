metaWRAP install : https://github.com/bxlab/metaWRAP
fq1 = $1
fq2 = $2
assembly outfile = $3
binning outfile = $4

metawrap assembly -1 $1 -2 $2  -o $3 -t 20 -m 2000

metawrap --metabat2 --maxbin2 --concoct -t 20 -m 2000 --run-checkm -a $3/final_assembly.fasta -o $4 $1 $2


gtdbtk annotation：
gtdbtk identify --genome_dir genomics-dir --out_dir identify --extension fa --cpus 40
gtdbtk align --identify_dir identify --out_dir align --cpus 40
gtdbtk classify --genome_dir genomics-dir --align_dir align --out_dir classify -x fa --cpus 40 

phylogenetic tree:
iqtree2 -s gtdbtk.bac120.user_msa.fasta -m MFP

card annotation:
rgi main --input_sequence genome_dir/*.fa --output_file $1_card --input_type protein -a DIAMOND -n 20 --clean

Functional annotation:
python emapper.py -m diamond -i genome_dir/*.fa --output result -d bact --cpu 5
