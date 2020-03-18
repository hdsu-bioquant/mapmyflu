# Make nucleotide db
makeblastdb -in map_my_corona_shiny/data/SARScov2_nucleotide.fasta -dbtype nucl -input_type 'fasta' -out map_my_corona_shiny/db/nucleotide/covid19 -taxid 2697049
# Make protein db
makeblastdb -in map_my_corona_shiny/data/SARScov2_protein.fasta -dbtype prot -input_type 'fasta' -out map_my_corona_shiny/db/protein/covid19 -taxid 2697049
