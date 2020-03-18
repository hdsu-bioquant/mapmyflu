# The arguments passed are 

#SCRIPT name
#ROOT directory
#Query sequence
#Is query DNA or Protein
#Number of threads to use

#Nucleotide

Rscript /icgc/dkfzlsdf/analysis/B080/crg/MapMyCorona/src/blast_script.R \
/icgc/dkfzlsdf/analysis/B080/crg/MapMyCorona/ \
/icgc/dkfzlsdf/analysis/B080/crg/MapMyCorona/testquery/SARScov2_query_nucleotide.fasta \
nucleotide \
30

#Protein

Rscript /icgc/dkfzlsdf/analysis/B080/crg/MapMyCorona/src/blast_script.R \
/icgc/dkfzlsdf/analysis/B080/crg/MapMyCorona/ \
/icgc/dkfzlsdf/analysis/B080/crg/MapMyCorona/testquery/SARScov2_query_protein.fasta \
protein \
30 
