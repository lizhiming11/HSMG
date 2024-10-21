#metaWRAP install : https://github.com/bxlab/metaWRAP
sample_name = $1

#assembly
metawrap assembly -1 $1.1.fq.gz -2 $1.2.fq.gz  -o $1 -t 20 -m 2000

metawrap --metabat2 --maxbin2 --concoct -t 20 -m 2000 --run-checkm -a $1/final_assembly.fasta -o $1_binning $1.1.fq.gz $1.2.fq.gz
#quality
DAS_TOOL -i metabat2_bin.tsv,maxbin2_bin.tsv,concoct_bin.tsv -l metabat,maxbin,concoct -c $1/final_assembly.fasta -o  DAS_out --search_engine diamond --write_bins 1
#High-quality (HQ) genomes (completeness >=90%, contamination <=5%), Medium-quality (MQ) genomes (completeness >=50%, contamination <=10%)
checkm lineage_wf DAS_out/ checkm_ann -x fa -t 20

#drep install : https://github.com/MrOlm/drep

#Merge the medium-quality and above MAGs into one folder.
#clustering
binning outfile = $4
dRep compare ./dRep/ -p 20 -pa 0.95 -sa 0.95 -g ./$4/*.fa > $4_compare.log

#Annotate the dereplicated representative genomes using GTDB (Genome Taxonomy Database).
#gtdbtk annotation：
gtdbtk identify --genome_dir genomics-dir --out_dir identify --extension fa --cpus 40
gtdbtk align --identify_dir identify --out_dir align --cpus 40
gtdbtk classify --genome_dir genomics-dir --align_dir align --out_dir classify -x fa --cpus 40 

#phylogenetic tree:
iqtree2 -s gtdbtk.bac120.user_msa.fasta -m MFP

#Functional annotation:
python emapper.py -m diamond -i genome_dir/*.fa --output result -d bact --cpu 5
