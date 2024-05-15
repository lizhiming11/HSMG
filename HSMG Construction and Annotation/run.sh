metaWRAP install : https://github.com/bxlab/metaWRAP
fq1 = $1
fq2 = $2
assembly outfile = $3
binning outfile = $4

metawrap assembly -1 $1 -2 $2  -o $3 -t 20 -m 2000

metawrap --metabat2 --maxbin2 --concoct -t 20 -m 2000 --run-checkm -a $3/final_assembly.fasta -o $4 $1 $2
DAS_TOOL -i metabat2_bin.tsv,maxbin2_bin.tsv,concoct_bin.tsv -l metabat,maxbin,concoct -c $3/final_assembly.fasta -o  DAS_out --search_engine diamond --write_bins 1

drep install : https://github.com/MrOlm/drep
dRep compare ./dRep_$4/ -p 20 -pa 0.95 -sa 0.95 -g ./$4/*.fa > $4_compare.log

gtdbtk annotation：
gtdbtk identify --genome_dir genomics-dir --out_dir identify --extension fa --cpus 40
gtdbtk align --identify_dir identify --out_dir align --cpus 40
gtdbtk classify --genome_dir genomics-dir --align_dir align --out_dir classify -x fa --cpus 40 

phylogenetic tree:
iqtree2 -s gtdbtk.bac120.user_msa.fasta -m MFP


Functional annotation:
python emapper.py -m diamond -i genome_dir/*.fa --output result -d bact --cpu 5
