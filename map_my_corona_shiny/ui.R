library(leaflet)
library(shinydashboard)
library(shinyWidgets)
library(shinyjs)


dashboardPage(
  
  dashboardHeader(title = "Map my Corona"),
  dashboardSidebar(
    sidebarMenu(
      # menuItem(
      #   "Maps",
      #   tabName = "maps",
      #   icon = icon("globe"),
      #   menuSubItem("Watersheds", tabName = "m_water", icon = icon("map")),
      #   menuSubItem("Population", tabName = "m_pop", icon = icon("map"))
      # ),
      
      # menuItem(
      #   "My plots",
      #   tabName = "plots",
      #   icon = icon("globe"),
      #   menuSubItem("Watersheds", tabName = "plots1", icon = icon("map")),
      #   menuSubItem("Population", tabName = "plots2", icon = icon("map"))
      # ),
      # menuItem(
      #   "Try", 
      #   tabName = "try", 
      #   icon = icon("globe")
      # ),
      
      menuItem(
        "Map", 
        tabName = "maps", 
        icon = icon("globe")
      ),
      # menuItem(
      #   "Data explorer", 
      #   tabName = "dataexplore", 
      #   icon = icon("bar-chart"),
      #   menuSubItem("Watersheds", tabName = "c_water", icon = icon("area-chart")),
      #   menuSubItem("Population", tabName = "c_pop", icon = icon("area-chart"))
      # )
      menuItem(
        "Data explorer", 
        tabName = "dataexplore", 
        icon = icon("bar-chart")
      ),
      
      # Horizontal line ----
      tags$hr(),
      h4("Search sequence", align = "center"),
      h6("from Fasta or from search box", align = "center"),
      
      # Input: Select a file ----
      fileInput("file1", "Choose Fasta File",
                multiple = FALSE,
                accept = c(".RDS", ".fa", ".fasta")),
      
      # Search fasta sequence
      textAreaInput("stringSequence", "Search sequence...", "> my_corona\natatataaccddf"),
      
      actionBttn(
        inputId = "searchSequence",
        label = "Submit",
        style = "jelly", 
        size  = "sm",
        color = "danger"
      ),
      h6("Click Submit without any input", align = "center"),
      h6("to display results for MT188340", align = "center"),
      #actionButton("searchSequence", label = "Submit"),
      
      # sidebarSearchForm(
      #   textId = "searchSequence", 
      #   buttonId = "searchButton",
      #   label = "Search sequence..."
      # ),
      
      br(),
      tags$hr(),
      h4("Options", align = "center"),
      #h6("from Fasta or from search box", align = "center"),
      
      awesomeRadio(
        inputId = "score_id",
        label = "Select score metric", 
        choices = c("Percent identity", "evalue", "bitscore"),
        selected = "Percent identity",
      )
      
      # Input: Selector for choosing Regulatory Variance metric ----
      #uiOutput("sel_country2")
      # selectInput(
      #   inputId = "sel_country",
      #   label = "Choose countries (default all):",
      #   choices = unique(blaster$Geo_Location),
      #   multiple = TRUE
      # )
    )
  ),
  dashboardBody(
    useShinyjs(),
    tabItems(
      # tabItem(
      #   tabName = "m_water",
      #   box(
      #     title = "Baltic catchment areas",
      #     collapsible = TRUE,
      #     width = "100%",
      #     height = "100%",
      #     leafletOutput("l_watershed")
      #   )
      # ),
      tabItem(
        tabName = "maps",
        fluidRow(
          box(
            height = 100, 
            width = 4, 
            background = "black",
            plotOutput(outputId = "gg_data_months")
          ),
          
          box(
            height = 100, 
            width = 4, 
            background = "black",
            uiOutput("date_range")
          ),
          
          box(
            height = 100,
            width = 4, 
            background = "black",
            # Input: Selector for choosing Regulatory Variance metric ----
            uiOutput("sel_country")
          )
          
        ),
        
        fluidRow(
          tags$style(type = "text/css", "#map {height: calc(100vh - 80px) !important;}"),
          box(
            #height = 300,
            width = 12, 
            leafletOutput("map")
          )
        )
      ),
      
      
      # tabItem(
      #   tabName = "maps",
      #   # Map in Dashboard
      #   #leafletOutput("map", width="100%", height="100%")
      #   tags$style(type = "text/css", "#map {height: calc(100vh - 80px) !important;}"),
      #   box("Box content here", br(), "More box content",)
      #   #leafletOutput("map")
      # ),
      
      tabItem(
        tabName = "dataexplore",
        div(style = 'overflow-x: scroll', 
            #DT::DTOutput("blaster"))
            #checkboxInput("dt_sel", "sel/desel all")
            DT::dataTableOutput('blaster_ui'))
        #DT::dataTableOutput("blaster")
      )
      
      
      # tabItem(
      #   tabName = "charts",
      #   h2("Second tab content")
      # )
    )
  ), 
  skin = "black"
)


