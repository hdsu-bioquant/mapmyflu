library(dplyr)
library(leaflet)
#------------------------------------------------------------------------------#
#           read data - Country Polygons GeoJSON as sp                         #
#------------------------------------------------------------------------------#
# Source
# https://datahub.io/core/geo-countries
# https://datahub.io/core/geo-countries/r/countries.geojson
countries <- readRDS("data/countries.RDS")


color_area_IDs <- c(col_collect = "Collection date of top hit in each country",
                    col_release = "Release date of top hit in each country",
                    none        = "none")

rand_fasta_name <- function(n = 5000) {
  a <- do.call(paste0, replicate(5, sample(LETTERS, n, TRUE), FALSE))
  #print(a)
  fa_id <- paste0(a, sprintf("%04d", sample(9999, n, TRUE)), sample(LETTERS, n, TRUE))
  paste0("data/", fa_id, ".fasta")
}


validate_fasta <- function(path_fa, type){
  x <- readLines(path_fa)
  #print(x)
  f <- substr(x, 1, 1)
  # Check if it has header
  if (f[1] != ">") {
    print("Sequence is not a valid fasta sequence")
    return(FALSE)
  }
  
  # Check if nuc or prot
  
  # Remove header
  x <- x[!substr(x, 1, 1) == ">"]
  
  if (length(x) == 0) {
    print("Only header provided")
    return(FALSE)
  }
  
  # collapse and get unique letters
  x <- paste(x, collapse = "")
  x <- unique(strsplit(x, "")[[1]]) 
  x <- toupper(x)
  #print(x)
  if (type == "protein") {
    isnuc <- x %in% c("A", "G", "C", "T", "N", "U")
    #print(isnuc)
    if (all(isnuc)) {
      print("None invalid characters but looks like nucleotide sequence")
      return(FALSE)
    }
    
    
  }
  
  
  if (type == "nucleotide") {
    nucs <- c("A", "C", "G", "T", "U", "R", "Y", "K", "M", 
              "S", "W", "B", "D", "H", "V", "N", "-")
  } else if (type == "protein") {
    nucs <- c("A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", 
              "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "Y",
              "Z", "X", "*", "-")
  }
  
  
  if (all(x %in% nucs)) {
    print("valid sequence")
    return(TRUE)
  } else {
    print("Not a valid sequence")
    return(FALSE)
  }
  
}


