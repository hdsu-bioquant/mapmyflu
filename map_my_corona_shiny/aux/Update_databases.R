#------------------------------------------------------------------------------#
#                       Script to update the databases                         #
#------------------------------------------------------------------------------#

# Download new fasta and annotation table from:
"https://www.ncbi.nlm.nih.gov/labs/virus/vssi/#/virus?SeqType_s=Protein&VirusLineage_ss=Severe%20acute%20respiratory%20syndrome%20coronavirus%202,%20taxid:2697049"
# Save the fasta and csv files to the archive folder
# for nucleotide: archive/nucleotide_fasta
# for protein: protein/nucleotide_fasta

library(dplyr)

#------------------------------------------------------------------------------#
#                       Update nucleotide database                             #
#------------------------------------------------------------------------------#
anno_query_nuc <- read.csv("archive/nucleotide_fasta/sequences.csv",
              header=TRUE, stringsAsFactors = FALSE) %>% 
  mutate(Geo_Location2 = Geo_Location) %>% 
  mutate(Geo_Location = sub(":.*", "", Geo_Location)) %>% 
  mutate(Geo_Location = if_else(Geo_Location == "Hong Kong", "China", Geo_Location))
saveRDS(anno_query_nuc, "data/SARScov2_nucleotide_metadata.RDS")


file.rename(from = "db/nucleotide/", to = "archive/nucleotideOld")
dir.create("db/nucleotide")
file.copy(from = "~/Downloads/sequences.fasta", to = "db/nucleotide/covid19.fasta")

# Create database
system(paste0("bin/binm/makeblastdb -in db/nucleotide/covid19.fasta -dbtype nucl -input_type 'fasta' -out  db/nucleotide/covid19 -taxid 2697049"), wait =T)


#------------------------------------------------------------------------------#
#                       Update protein database                             #
#------------------------------------------------------------------------------#
anno_query_prot <- read.csv("archive/protein_fasta/sequences.csv",
                           header=TRUE, stringsAsFactors = FALSE) %>% 
  mutate(Geo_Location2 = Geo_Location) %>% 
  mutate(Geo_Location = sub(":.*", "", Geo_Location)) %>% 
  mutate(Geo_Location = if_else(Geo_Location == "Hong Kong", "China", Geo_Location))
saveRDS(anno_query_prot, "data/SARScov2_protein_metadata.RDS")


file.rename(from = "db/protein/", to = "archive/proteinOld")
dir.create("db/protein")
#file.copy(from = "~/Downloads/sequences.fasta", to = "db/nucleotide/covid19.fasta")

# Create database
system(paste0("bin/binm/makeblastdb -in archive/protein_fasta/sequences.fasta -dbtype prot -input_type 'fasta' -out  db/protein/covid19 -taxid 2697049"), wait =T)
