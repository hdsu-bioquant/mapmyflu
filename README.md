# MapMyCorona

## BLAST - Alignment step
The directory `MapMyCorona_BLAST` contains the following -

```
├── data
│   ├── SARScov2_nucleotide.fasta
│   ├── SARScov2_nucleotide_metadata.csv
│   ├── SARScov2_protein.fasta
│   └── SARScov2_protein_metadata.csv
├── src
│   ├── blast_script.R
│   ├── MapMyCorona.yaml
│   └── README.txt
└── testquery
    ├── SARScov2_query_nucleotide.fasta
    └── SARScov2_query_protein.fasta
```

This directory needs to be copied to a location of interest, following which the `blast_script.R` needs to be executed. This directory contains the latest sequences (both protein and nucleotide) for SARS CoV-2 along with the associated metadata. I have also created two test query sequences that should appear by default in the app landing page.

### The arguments that needs to be passed to `Rscript` are -

- SCRIPT name
- ROOT directory
- Query sequence
- Is query DNA or Protein
- Number of threads to use

Examples for aligning nucleotide and protein sequences are shown below -

### Nucleotide

```
Rscript /icgc/dkfzlsdf/analysis/B080/crg/MapMyCorona/src/blast_script.R \
/icgc/dkfzlsdf/analysis/B080/crg/MapMyCorona/ \
/icgc/dkfzlsdf/analysis/B080/crg/MapMyCorona/testquery/SARScov2_query_nucleotide.fasta \
nucleotide \
30
```

### Protein

```
Rscript /icgc/dkfzlsdf/analysis/B080/crg/MapMyCorona/src/blast_script.R \
/icgc/dkfzlsdf/analysis/B080/crg/MapMyCorona/ \
/icgc/dkfzlsdf/analysis/B080/crg/MapMyCorona/testquery/SARScov2_query_protein.fasta \
protein \
30 
```
### Output

The alignment output merged with annotation data will be located in - 
```
ROOTDIR
.
├── alignment
│   ├── nucleotide
│   │   ├── SARScov2_nucleotide_alignment.tsv
│   │   └── SARScov2_nucleotide_alignment_with_annotation.tsv
│   └── protein
│       ├── SARScov2_protein_alignment.tsv
│       └── SARScov2_protein_alignment_with_annotation.tsv
```

## Shiny App

TO BE UPDATED
