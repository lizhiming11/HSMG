SNV:
bwa mem -t 20 -R "@RG\tID:$1\tLB:$1\tPL:ILLUMINA\tPM:HISEQ\tSM:$1" representative.fa $1.rm.1.fq.gz $1.rm.2.fq.gz > $1.sam 
samtools view -bS -@ 20 $1.sam > $1.bam 
samtools sort $1.bam $1.sort
inStrain profile $1.sort.bam representative.fa -o $1_result -p 10 -g skin_genomes.fna -s skin_genomes.stb --database_mode --skip_genome_wide

BGC:
deepbgc pipeline --prodigal-meta-mode --score 0.8 -o $1_deepbgc $1.fa
run_antismash $1.fa $1_antismash

HGT：
MetaCHIP PI -p Species -r s -t 40 -i file/ -x fa -taxon SGB_gtdbtk.bac120.summary2.tsv
MetaCHIP BP -p Species -r s -t 40
