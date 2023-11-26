sample = $1

conda activate metawrap
metawrap assembly -1 $sample.rmhost.1.fq.gz -2 $sample.rmhost.2.fq.gz  -o 2.Assembly/$sample -t 20 -m 2000
