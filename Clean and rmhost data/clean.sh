sample_name = $1
hg38_database = $2
fastp -i $sample_name.1.fq.gz -I $sample_name.2.fq.gz -u 45 -q 20 -u 5 -o $sample_name_clean.1.fq.gz -O $sample_name_clean.2.fq.gz
bowtie2 -p 20 -x $hg38_database -1 $sample_name_clean.1.fq.gz -2 $sample_name_clean.2.fq.gz -S $1.sam --un-conc $1_rm.fq> $1.rm_log
pigz -p 20 $1_rm.1.fq
pigz -p 20 $1_rm.2.fq
rm $1.sam
