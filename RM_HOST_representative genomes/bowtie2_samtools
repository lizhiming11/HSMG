
bowtie2 -p 20 -x /hwfssz5/ST_HEALTH/P20H10200N0068/lizhiming/database/BMTAGGER_INDEX/hg38.fa.index -U ../$1.fastq -S ./$1.sam --very-sensitive
samtools view -@ 20 -bS $1.sam > $1.bam
samtools view -@ 20 -b -F 4 $1.bam > $1.mapped.bam
samtools view -@ 20 $1.mapped.bam | wc -l> $1.mapped.bam_num
