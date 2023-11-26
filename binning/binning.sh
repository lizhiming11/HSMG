conda activate metawrap
sample = $1
metawrap binning --metabat2 --maxbin2 --concoct -t 20 -m 2000 --run-checkm -a 2.Assembly/$sample/final_assembly.fasta -o binning/$sample ./1.Cleandata/$sample_1.fastq ./1.Cleandata/$sample_2.fastq
