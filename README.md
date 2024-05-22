# Identify-Homologs-in-Bacterial-Genome
## Background
Many genes encode for proteins. Within a folded protein, there are specific regions called domains. Each domain typically has a distinct function. For example, histidine kinase (HK) domains are involved in signal transduction. They help transmit signals sensed by other domains within the same protein.

This script uses bioinformatics tools to query amino acid sequences to identify homologous sequences in bacterial genome. Then, it reads a BED file to determine which genes contain the identified HK domains. The BED file contains genomic coordinates for genes. The script outputs the unique gene names, which have been identified as containing the predicted HK domains.

## Usage
Usage of the script is:

```
homologs_identify.sh <query.faa> <subject.fna> <bedfile> <outfile>
```

For example:

```
./homologs_identify.sh data/HK_domain.faa data/Escherichia_coli_K12.fna bed_files/Escherichia_coli_K12.bed output_Escherichia_coli_K12.txt
```

To run the script in a loop on the 3 genomes provided and their associated BED files:

```
for file in bed_files/*; do
  ./homologs_identify.sh data/HK_domain.faa data/$(basename ${file%.*}).fna bed_files/$file output_$(basename ${file%.*}).txt
done
```
