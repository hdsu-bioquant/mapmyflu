library(leaflet)
library(RColorBrewer)
library(scales)
library(ggplot2)
#library(lattice)
library(dplyr)
library(shinyjs)
#library(ggsci)


function(input, output, session) {
  #----------------------------------------------------------------------------#
  #                               read data                                    #
  #----------------------------------------------------------------------------#
  
  #-----------------------------------------------------------------#
  #                            read BLAST result                    #
  #-----------------------------------------------------------------#
  
  blaster_react <- eventReactive(input$searchSequence, {
    
    if(is.null(input$file1$datapath)){
      my_path <- "data/blaster.RDS"
    } else {
      my_path <- input$file1$datapath
    }
    #print(input$stringSequence)
    #print(my_path)
    x <- readRDS(my_path) %>% 
      mutate(collection_months = substr(Collection_Date, 1, 7)) %>% 
      mutate(evalue_log10 = -log10(evalue + 0.000001))
    #print(head(x))
    
    reset("file1")
    #print(input$file1$datapath)
    x
    
  })
  
  #-----------------------------------------------------------------#
  #                        format BLAST result                      #
  #-----------------------------------------------------------------#
  blaster_form_react <- eventReactive({
    input$score_id
    input$searchSequence
    }, {
    
    
    score_ids <- c(pident = "Percent identity",
                   evalue_log10 = "evalue",
                   bitscore = "bitscore")
    score_id <- names(score_ids)[score_ids %in% input$score_id]
    
    
    x <- blaster_react() %>% 
      filter(!Geo_Location == "") %>% 
      mutate(radius = cut(!! sym(score_id), 4)) 
    radius_levels <- setNames(seq(2, 8, 2), levels(x$radius))
    #radius_levels <- setNames(seq(3, 12, 3), levels(blaster$radius))
    x <- x %>% 
      mutate(radius = recode(radius, !!!radius_levels)) %>% 
      group_by(Geo_Location) %>% 
      mutate(idx_location = 1:n()) %>% 
      mutate(radiusfix = if_else(idx_location == 1 & sum(idx_location) > 1, 12, radius )) %>% 
      ungroup() %>% 
      mutate(radiusfix = factor(radiusfix, levels = sort(unique(radiusfix))))
    
    dots_pal <- colorFactor(c("grey20", "grey40", "grey60", "Tomato"), domain = levels(x$radius))
    #------------------------------------#
    #         Country mapper to sp       #
    #------------------------------------#
    #countries
    
    # Country mapper
    country_mapper <- data.frame(blast_id_orig = unique(x$Geo_Location),
                                 blast_id = tolower(unique(x$Geo_Location)), 
                                 stringsAsFactors = FALSE) %>% 
      mutate(ADMIN  = match(blast_id, tolower(countries$ADMIN))) %>% 
      mutate(ISO_A3 = match(blast_id, tolower(countries$ISO_A3))) %>% 
      mutate(mapper = if_else(!is.na(ADMIN), ADMIN, ISO_A3)) %>% 
      filter(!is.na(mapper))
    
    
    # keep only countries in the blast results
    my_countries <- countries[country_mapper$mapper,]
    my_countries$blast_id <- country_mapper$blast_id_orig
    
    #print(country_mapper)
    
    
    # Add color by date
    #my_countries$col_release <- blaster_summ$Collection_Date2[match(countries_react$blast_id, blaster_summ$Geo_Location)]
    #my_countries$col_collect <- blaster_summ$Collection_Date2[match(countries_react$blast_id, blaster_summ$Geo_Location)]
    #print(countries_react@data)
    
    x <- x %>% 
      # Fix collection date color
      mutate(Collection_Date2 = if_else(nchar(Collection_Date) == 7,
                                        paste0(Collection_Date, "-32"),
                                        Collection_Date)) %>% 
      mutate(fixdate = as.Date(gsub("32$", "15", Collection_Date2)))%>%
      mutate(fixdate2 = cut.Date(fixdate, 6, labels = FALSE)) %>%
      mutate(fixdate3 = cut.Date(fixdate, 6)) %>%
      mutate(col_collect = sort(unique(as.character(fixdate3)))[fixdate2]) %>% 
      # Fix Release date color
      mutate(fixdate = as.Date(Release_Date))%>%
      mutate(fixdate2 = cut.Date(fixdate, 6, labels = FALSE)) %>%
      mutate(fixdate3 = cut.Date(fixdate, 6)) %>%
      mutate(col_release = sort(unique(as.character(fixdate3)))[fixdate2]) 
    
    
    # select(Accession, pident, evalue, bitscore, Geo_Location, Host,
    #        Release_Date, Collection_Date, length, mismatch, gapopen,
    #        qstart, qend, sstart, send, Length, Isolation_Source, Species) %>% 
    # 
    # x <- countries_react@data %>%
    #   mutate(fixdate = as.Date(gsub("32$", "15", density)))%>%
    #   mutate(fixdate2 = cut.Date(fixdate, 6, labels = FALSE)) %>%
    #   mutate(fixdate3 = cut.Date(fixdate, 6)) %>%
    #   mutate(fixdate = sort(unique(as.character(fixdate3)))[fixdate2])
    # 
    # countries_react$density <- x$fixdate
    
    
    
    
    
    
    #------------------------------------#
    #     Ad coordinates to blaster      #
    #------------------------------------#
    #countries$blast_id
    idx <- match(x$Geo_Location, my_countries$blast_id)
    x$longitude <- my_countries$longitude[idx]
    x$latitude <- my_countries$latitude[idx]
    
    x$dots_lab <- paste(sep = "<br/>",
                        paste0("<b><a href='https://www.ncbi.nlm.nih.gov/nuccore/", 
                               x$Accession, 
                               "'>", 
                               x$Accession, 
                               "</a></b>"),
                        paste0("Host : ", x$Host),
                        paste0("Geo Location : ", x$Geo_Location),
                        paste0("Collection Date : ", x$Collection_Date),
                        paste0("Release Date : ", x$Release_Date),
                        paste0("percent identity = ", x$pident),
                        paste0("evalue = ", x$evalue),
                        paste0("bitscore = ", x$bitscore)
    ) 
    list(df           = x,
         my_countries = my_countries,
         dots_pal     = dots_pal)
    
  })
  
  
  
  #----------------------------------------------------------------------------#
  #                           Reactive widgets                                 #
  #----------------------------------------------------------------------------#
  # Country selector
  output$sel_country <- renderUI({
    selectInput(
      inputId = "sel_country",
      label = "Choose countries (default all):",
      choices = unique(na.omit(blaster_react()$Geo_Location)),
      multiple = TRUE
    )
  })
  
  # Date selector
  output$date_range <- renderUI({
    
    collection_months <- sort(unique(blaster_react()$collection_months))
    sliderTextInput(
      inputId = "date_range",
      label = "Date Range:", 
      choices = collection_months,
      selected = collection_months[c(1, length(collection_months))]
    )
  })
  
  
  
  #----------------------------------------------------------------------------#
  #                                       Map                                  #
  #----------------------------------------------------------------------------#
  
  ## Interactive Map ###########################################

  # Create the map
  output$map <- renderLeaflet({
    leaflet() %>%
      setView(42, 16, 2) %>% 
      addProviderTiles(providers$CartoDB.DarkMatter)
  })
  
  fil_by_location <- function() {
    if (length(input$sel_country) == 0) {
      #input$sel_country
      unique(blaster_react()$Geo_Location)
    } else {
      input$sel_country
    }
  }
  
  fil_by_collection_date <- function() {
    if (length(input$date_range) == 0) {
      #input$sel_country
      c(min(blaster_react()$collection_months), max(blaster_react()$collection_months))
    } else {
      input$date_range
    }
  }
  #----------------------------------------------------------------------------#
  #                              Color areas                                   #
  #----------------------------------------------------------------------------#

  observe({

    blaster_summ <- blaster_form_react()$df %>%
      filter(Geo_Location %in% fil_by_location()) %>%
      filter(collection_months >= fil_by_collection_date()[1] &
               collection_months <= fil_by_collection_date()[2]) %>%
      mutate(Collection_Date2 = if_else(nchar(Collection_Date) == 7,
                                        paste0(Collection_Date, "-32"),
                                        Collection_Date)) %>%
      # for each country keep only the top hit
      group_by(Geo_Location) %>%
      top_n(n = 1, pident) %>%
      top_n(n = 1, -evalue) %>%
      top_n(n = 1, bitscore) %>%
      top_n(n = -1, Collection_Date2) %>%
      top_n(n = -1, Release_Date) %>%
      # If there's more than one entry keep only the first one
      mutate(cums = 1) %>%
      mutate(cums = cumsum(cums)) %>%
      filter(cums == 1)

    #print(blaster_summ)


    countries_react <- blaster_form_react()$my_countries[blaster_form_react()$my_countries$blast_id %in% blaster_summ$Geo_Location,]

    countries_react$density <- blaster_summ$Collection_Date2[match(countries_react$blast_id, blaster_summ$Geo_Location)]
    countries_react$density <- blaster_summ$col_collect[match(countries_react$blast_id, blaster_summ$Geo_Location)]
    #print(countries_react@data)
    
    
    # <- x %>% 
    #   # Fix collection date color
    #   mutate(fixdate = as.Date(gsub("32$", "15", Collection_Date2)))%>%
    #   mutate(fixdate2 = cut.Date(fixdate, 6, labels = FALSE)) %>%
    #   mutate(fixdate3 = cut.Date(fixdate, 6)) %>%
    #   mutate(col_collect = sort(unique(as.character(fixdate3)))[fixdate2]) %>% 
    #   # Fix Release date color
    #   mutate(fixdate = as.Date(Release_Date))%>%
    #   mutate(fixdate2 = cut.Date(fixdate, 6, labels = FALSE)) %>%
    #   mutate(fixdate3 = cut.Date(fixdate, 6)) %>%
    #   mutate(col_release = sort(unique(as.character(fixdate3)))[fixdate2]) 

    # x <- countries_react@data %>%
    #   mutate(fixdate = as.Date(gsub("32$", "15", density)))%>%
    #   mutate(fixdate2 = cut.Date(fixdate, 6, labels = FALSE)) %>%
    #   mutate(fixdate3 = cut.Date(fixdate, 6)) %>%
    #   mutate(fixdate = sort(unique(as.character(fixdate3)))[fixdate2])
    # 
    # countries_react$density <- x$fixdate
    print(countries_react@data)
    # print(sort(unique(countries_react$density)))

    pal <- colorFactor("YlOrRd", domain = sort(unique(countries_react$density)))

    leafletProxy("map", data = blaster_summ) %>%
      clearControls() %>%
      clearShapes() %>%
      addPolygons(data = countries_react,
                  fillColor = ~pal(countries_react$density),
                  weight = 0.5,
                  opacity = 1,
                  color = "white",
                  dashArray = "3",
                  fillOpacity = 0.7
                  ) %>%
      addLegend(pal = pal, values = ~countries_react$density, opacity = 0.7, title = NULL,
                position = "bottomright")
  })
  
  #----------------------------------------------------------------------------#
  #                              Add clusters                                  #
  #----------------------------------------------------------------------------#

  observe({
    blaster_map <- blaster_form_react()$df %>%
      filter(Geo_Location %in% fil_by_location()) %>%
      filter(collection_months >= fil_by_collection_date()[1] &
               collection_months <= fil_by_collection_date()[2])


    print(dim(blaster_map))
    print(input$date_range)

    #print(class(blaster_react))

    dots_pal <- blaster_form_react()$dots_pal
    #dots_pal <- colorFactor(c("grey20", "grey40", "grey60", "Tomato"), domain = levels(blaster_map$radius))

    leafletProxy("map", data = blaster_map) %>%
      clearMarkerClusters() %>%
      clearMarkers() %>%
      addCircleMarkers(lng = blaster_map$longitude,
                       lat = blaster_map$latitude,
                       radius = blaster_map$radiusfix,
                       color = ~dots_pal(blaster_map$radius),
                       clusterOptions = markerClusterOptions(
                         spiderfyDistanceMultiplier=1.2
                       ),
                       popup = blaster_map$dots_lab,
                       fillOpacity = 1)
  })

  
  
  # 
  # ## Data Explorer ###########################################
  ##--------------------------------------------------------------------------##
  ##              Get main table and fitler according to options              ##
  ##--------------------------------------------------------------------------##
  
  output$blaster_ui <- DT::renderDataTable({
    
    df <- blaster_form_react()$df %>% 
      mutate(Release_Date = as.Date.character(Release_Date)) %>%
      filter(collection_months >= fil_by_collection_date()[1] &
               collection_months <= fil_by_collection_date()[2]) %>% 
      select(Accession, pident, evalue, bitscore, Geo_Location, Host,
             Release_Date, Collection_Date, length, mismatch, gapopen,
             qstart, qend, sstart, send, Length, Isolation_Source, Species) %>% 
      filter(Geo_Location %in% fil_by_location()) 
      
      
    action <- DT::dataTableAjax(session, df, outputId = "blaster_ui")
    
    DT::datatable(df, options = list(ajax = list(url = action)), escape = FALSE, class = "nowrap display")
  })
  
  
  
  
  observe(
    output$gg_data_months <- renderPlot({
      
      # Input data is filtered 
      blaster_form_react()$df %>% 
        filter(Geo_Location %in% fil_by_location()) %>% 
        filter(collection_months >= fil_by_collection_date()[1] &
                 collection_months <= fil_by_collection_date()[2]) %>% 
        mutate(collection_months = factor(collection_months, 
                                          levels = sort(unique(collection_months)))) %>% 
        ggplot(aes(x = collection_months, fill = collection_months)) +
        geom_bar(stat = "count") +
        theme_dark() + 
        #scale_fill_tron()  +
        theme(#legend.position = "none",
          text = element_text(colour = "white"),
          axis.text.x = element_text(colour = "white"),
          axis.text.y = element_text(colour = "white"),
          plot.background =element_rect(fill = "#2D2D2D"),
          panel.background = element_rect(fill = "#2D2D2D"),
          axis.line=element_blank(),
          
          axis.ticks=element_blank(),
          axis.title.x=element_blank(),
          #axis.title.y=element_blank(),
          panel.grid = element_blank(),
          legend.position="none") 
      
        
    },
    #width  = 100, 
    height = 80
    )
  )
  
  
  
  
  
}
