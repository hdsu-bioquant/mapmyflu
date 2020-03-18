#Initialization
args = commandArgs(trailingOnly = TRUE)

path    = as.character(args[1])
query   = as.character(args[2])
type    = as.character(args[3])
threads = as.numeric(args[4])

#Create the necessary directory structure
if(!dir.exists(paste0(path,"db"))) dir.create(paste0(path,"db"))
if(!dir.exists(paste0(path,"db/nucleotide"))) dir.create(paste0(path,"db/nucleotide"))
if(!dir.exists(paste0(path,"db/protein"))) dir.create(paste0(path,"db/protein"))

if(!dir.exists(paste0(path,"alignment"))) dir.create(paste0(path,"alignment"))
if(!dir.exists(paste0(path,"alignment/nucleotide"))) dir.create(paste0(path,"alignment/nucleotide"))
if(!dir.exists(paste0(path,"alignment/protein"))) dir.create(paste0(path,"alignment/protein"))

doBLAST = function(type, query){
  
  if(type == "nucleotide"){
    id = 'nucl'
  }else if(type == "protein"){
    id = 'prot'
  }else{stop("Wrong type name !!")}
  
  #TODO: add check for the query type to mach query sequence i.e dont supply DNA for protein alignment and vice versa
  
  system(paste0("makeblastdb -in ", paste0(path, "data/SARScov2_", type,".fasta"), " -dbtype ", id, " -input_type 'fasta' -out ",  paste0(path, "db/", type, "/covid19"), " -taxid 2697049"), wait =T)
  
  if(type == "nucleotide"){
    system(paste0("blastn -query ", query, " -task 'megablast' -db ", paste0(path, "db/", type, "/covid19"), " -outfmt 6 -num_threads ", threads, " > ", paste0(path, 'alignment/', type, '/SARScov2_', type, '_alignment.tsv')), wait = T)
  }else if(type == "protein"){
  system(paste0("blastp -query ", query, " -task 'blastp' -db ", paste0(path, "db/", type, "/covid19"), " -outfmt 6 -num_threads ", threads, " > ", paste0(path, 'alignment/', type, '/SARScov2_', type, '_alignment.tsv')), wait = T)
  }
  
  align = read.delim(paste0(path, 'alignment/', type, '/SARScov2_', type, '_alignment.tsv'), header=F)
  colnames(align) = c("qaccver", "Accession", "pident", "length", "mismatch", "gapopen", "qstart", "qend", "sstart", "send", "evalue", "bitscore")
  
  anno  = read.csv(paste0(path, "data/SARScov2_", type,"_metadata.csv"), header=T)
  align = merge(align, anno, by = "Accession")
  align = align[order(align$pident, - align$evalue, align$bitscore, decreasing = T),]
  
  write.table(align, paste0(path, 'alignment/', type, '/SARScov2_', type, '_alignment_with_annotation.tsv'), quote=F, row.names = F, sep="\t")
}

doBLAST(type = type, query = query)

#------------------------------
# Multiple sequence alignment
#------------------------------

#library(Biostrings)
#library(msa)

# multiseq = readDNAStringSet(paste0(path, "data/SARScov2_", type,".fasta"))
# multiseq.aln = msa(multiseq)
# msaPrettyPrint(multiseq.aln, output="asis", showNames="none",
#                showLogo="none", askForOverwrite=FALSE, verbose=FALSE)

