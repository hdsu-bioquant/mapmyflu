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

# score_ids <- c(pident = "Percent identity",
#                evalue = "evalue",
#                bitscore = "bitscore")

# blaster <- readRDS("data/blaster.RDS") %>% 
#   filter(!Geo_Location == "")
# 
# score_id <- "pident"
# 
# blaster <- readRDS("data/blaster.RDS") %>% 
#   filter(!Geo_Location == "") %>% 
#   mutate(radius = cut(!! sym(score_id), 4)) 
# radius_levels <- setNames(seq(2, 8, 2), levels(blaster$radius))
# #radius_levels <- setNames(seq(3, 12, 3), levels(blaster$radius))
# blaster <- blaster %>% 
#   mutate(radius = recode(radius, !!!radius_levels)) %>% 
#   group_by(Geo_Location) %>% 
#   mutate(idx_location = 1:n()) %>% 
#   mutate(radiusfix = if_else(idx_location == 1 & sum(idx_location) > 1, 12, radius )) %>% 
#   ungroup() %>% 
#   mutate(radiusfix = factor(radiusfix, levels = sort(unique(radiusfix))))
# 
# 
# #------------------------------------------------------------------------------#
# #                            Country mapper to sp                              #
# #------------------------------------------------------------------------------#
# all_countries <- countries
# 
# # Country mapper
# country_mapper <- data.frame(blast_id_orig = unique(blaster$Geo_Location),
#                              blast_id = tolower(unique(blaster$Geo_Location)), 
#                              stringsAsFactors = FALSE) %>% 
#   mutate(ADMIN  = match(blast_id, tolower(countries$ADMIN))) %>% 
#   mutate(ISO_A3 = match(blast_id, tolower(countries$ISO_A3))) %>% 
#   mutate(mapper = if_else(!is.na(ADMIN), ADMIN, ISO_A3)) %>% 
#   filter(!is.na(mapper))
# # mutate(ADMIN  = countries$ADMIN[match(blast_id, tolower(countries$ADMIN))]) %>% 
# # mutate(ISO_A3 = countries$ISO_A3[match(blast_id, tolower(countries$ISO_A3))]) %>% 
# # mutate()
# 
# # keep only countries in the blast results
# countries <- countries[country_mapper$mapper,]
# countries$blast_id <- country_mapper$blast_id_orig
# 
# 
# #countries$density <- blaster_summ$Score[match(countries$blast_id, blaster_summ$Geo_Location)]
# #countries$density <- blaster_summ$pident[match(countries$blast_id, blaster_summ$Geo_Location)]
# #print(countries@data)
# 
# 
# #------------------------------------------------------------------------------#
# #                          Ad coordinates to blaster                           #
# #------------------------------------------------------------------------------#
# #countries$blast_id
# idx <- match(blaster$Geo_Location, countries$blast_id)
# blaster$longitude <- countries$longitude[idx]
# blaster$latitude <- countries$latitude[idx]



#dots_pal <- colorFactor(c("grey20", "grey40", "grey60", "Tomato"), domain = levels(blaster$radius))


#blaster_summ <- readRDS("data/blaster_summ.RDS")
#print(head(blaster_summ))
#print(head(zipdata))

# allzips <- readRDS("data/superzip.rds")
# allzips$latitude <- jitter(allzips$latitude)
# allzips$longitude <- jitter(allzips$longitude)
# allzips$college <- allzips$college * 100
# allzips$zipcode <- formatC(allzips$zipcode, width=5, format="d", flag="0")
# row.names(allzips) <- allzips$zipcode
# 
# cleantable <- allzips %>%
#   select(
#     City = city.x,
#     State = state.x,
#     Zipcode = zipcode,
#     Rank = rank,
#     Score = centile,
#     Superzip = superzip,
#     Population = adultpop,
#     College = college,
#     Income = income,
#     Lat = latitude,
#     Long = longitude
#   )
