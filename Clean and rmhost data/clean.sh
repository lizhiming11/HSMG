fq1 = $1
fq2 = $2
outfile = $3


fastp -i $fq1 -I $fq2 -u 45 -q 20 -u 5 -o $outfile_clean.1.fq.gz -O $outfile_clean.2.fq.gz
