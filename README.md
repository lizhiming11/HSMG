Program for the construction of HSMG and analysis scripts in "A human skin microbiome reference catalog and the skin microbial landscape of plateau adults".

# Requirements

- [fastp v0.23.2](https://github.com/OpenGene/fastp)
- [Bowtie2 v2.3.5.1](https://github.com/BenLangmead/bowtie2)
- [megahit v1.1.3](https://github.com/voutcn/megahit)
- [metaBAT2 v2.15](https://gensoft.pasteur.fr/docs/MetaBAT/2.15/)
- [MaxBin2 v2.2.7](https://academic.oup.com/bioinformatics/article/32/4/605/1744462)
- [CONCOCT v1.1.0](https://concoct.readthedocs.io/en/latest/)
- [MetaWRAP v1.1.5](https://github.com/bxlab/metaWRAP)
- [DASTool v1.1.2](https://github.com/cmks/DAS_Tool)
- [CheckM v1.1.2](https://github.com/Ecogenomics/CheckM)
- [dRep v2.2.4](https://github.com/MrOlm/drep)
- [Samtools v1.5](https://github.com/samtools/samtools)
- [GTDB-Tk v1.3.1](https://github.com/Ecogenomics/GTDBTk)
- [IQ-TREE v2.1.2](http://www.iqtree.org/)
- [prodigal v2.6.3](https://github.com/hyattpd/Prodigal.git)
- [EggNOG v5.0](https://eggnog5.embl.de/)

"Clean and rmhost data" is a script for removing low-quality reads and host DNA from fastq files. The script is run with the following command: sh clean_rmhost.sh sample_name.

"HSMG Construction and Annotation" includes several key stages: sequence assembly, binning, quality control of MAGs (Metagenome-Assembled Genomes), quality assessment, dereplication, species annotation using GTDB (Genome Taxonomy Database), and functional annotation. Considering the computational demands of the intermediate processes, it is advisable to conduct the analysis in a step-by-step manner.

"RM_HOST_representative genomes" contains scripts for identifying the host proportion in assembled MAGs. The process involves two main steps: 1. K-mer Splitting: Initially, the MAGs are split into k-mers using the script generate_fastq_custom_threads.py. This script is run with the following command:python generate_fastq_custom_threads.py input.fasta output.fastq num_threads. This command converts the input FASTA file into an output FASTQ file, with the process parallelized over the specified number of threads. 2. Alignment Using Bowtie2: Subsequently, the generated FASTQ files are aligned to the human hg38 genome using Bowtie2. This step involves counting and calculating the proportion of reads that align to the human genome to determine the extent of host contamination.

"figure1-figure5" refers to the primary data and scripts associated with the main figures (Figure 1 to Figure 5) in a research article. This typically implies that each figure's underlying data and the scripts used for analysis and visualization are organized and named according to the figure they correspond to, facilitating easy identification and replication of the results presented in the figures.
