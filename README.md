# Background
Many genes encode for proteins. Within a folded protein, there are specific regions called domains. Each domain typically has a distinct function. For example, histidine kinase (HK) domains are involved in signal transduction. They help transmit signals sensed by other domains within the same protein.

This script uses bioinformatics tools to query amino acid sequences to identify homologous sequences in bacterial genome. Then, it reads a BED file to determine which genes contain the identified HK domains. The BED file contains genomic coordinates for genes. The script outputs the unique gene names, which have been identified as containing the predicted HK domains.

## Usage
To run the script:

```
homolog_identify.sh <query.faa> <subject.fna> <bedfile> <outfile>
```
