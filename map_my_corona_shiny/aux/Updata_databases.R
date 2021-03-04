#------------------------------------------------------------------------------#
#                       Script to update the databases                         #
#------------------------------------------------------------------------------#

# Download new fasta and annotation table from:
"https://www.ncbi.nlm.nih.gov/labs/virus/vssi/#/virus?SeqType_s=Protein&VirusLineage_ss=Severe%20acute%20respiratory%20syndrome%20coronavirus%202,%20taxid:2697049"
# Save the fasta and csv files to the archive folder
# for nucleotide: archive/nucleotide_fasta
# for protein: protein/nucleotide_fasta

library(dplyr)
anno_query <- read.csv("data/SARScov2_nucleotide_metadata.csv",
                       header=TRUE, stringsAsFactors = FALSE)

anno_query %>% 
  mutate(Geo_Location2 = Geo_Location) %>% 
  mutate(Geo_Location = sub(":.*", "", Geo_Location)) %>% 
  head()



anno_query_nuc <- read.csv("~/Downloads/sequences.csv",
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
