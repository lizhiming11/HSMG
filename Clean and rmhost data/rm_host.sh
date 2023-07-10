fq1 = $1
fq2 = $2
hg38 = $3
outfile = $4

bowtie2 -p 20 -x $3 -1 $1 -2 $2 -S $4.sam --un-conc $3_rm.fq> $4.rm_log
pigz -p 20 $4_rm.1.fq
pigz -p 20 $4_rm.2.fq
rm $4.sam
