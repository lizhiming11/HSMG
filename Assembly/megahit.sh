metaWRAP install : https://github.com/bxlab/metaWRAP
fq1 = $1
fq2 = $2
outfile = $3

metawrap assembly -1 $1 -2 $2  -o $3 -t 20 -m 2000
