library(leaflet)
library(shinydashboard)
library(shinyWidgets)
library(shinyjs)

# # Choices for drop-downs
# vars <- c(
#   "Is SuperZIP?" = "superzip",
#   "Centile score" = "centile",
#   "College education" = "college",
#   "Median income" = "income",
#   "Population" = "adultpop"
# )
# 
# 
# navbarPage("Map my Corona", id="nav",
# 
#   tabPanel("Interactive map",
#     div(class="outer",
# 
#       tags$head(
#         # Include our custom CSS
#         includeCSS("styles.css"),
#         includeScript("gomap.js")
#       ),
# 
#       # If not using custom CSS, set height of leafletOutput to a number instead of percent
#       leafletOutput("map", width="100%", height="100%"),
# 
#       # Shiny versions prior to 0.11 should use class = "modal" instead.
#       absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
#         draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
#         width = 330, height = "auto",
# 
#         h2("ZIP explorer"),
# 
#         selectInput("color", "Color", vars),
#         selectInput("size", "Size", vars, selected = "adultpop"),
#         conditionalPanel("input.color == 'superzip' || input.size == 'superzip'",
#           # Only prompt for threshold when coloring or sizing by superzip
#           numericInput("threshold", "SuperZIP threshold (top n percentile)", 5)
#         ),
# 
#         plotOutput("histCentile", height = 200),
#         plotOutput("scatterCollegeIncome", height = 250)
#       ),
# 
#       tags$div(id="cite",
#         'Data compiled for ', tags$em('Coming Apart: The State of White America, 1960–2010'), ' by Charles Murray (Crown Forum, 2012).'
#       )
#     )
#   ),
# 
#   tabPanel("Data explorer",
#     fluidRow(
#       column(3,
#         selectInput("states", "States", c("All states"="", structure(state.abb, names=state.name), "Washington, DC"="DC"), multiple=TRUE)
#       ),
#       column(3,
#         conditionalPanel("input.states",
#           selectInput("cities", "Cities", c("All cities"=""), multiple=TRUE)
#         )
#       ),
#       column(3,
#         conditionalPanel("input.states",
#           selectInput("zipcodes", "Zipcodes", c("All zipcodes"=""), multiple=TRUE)
#         )
#       )
#     ),
#     fluidRow(
#       column(1,
#         numericInput("minScore", "Min score", min=0, max=100, value=0)
#       ),
#       column(1,
#         numericInput("maxScore", "Max score", min=0, max=100, value=100)
#       )
#     ),
#     hr(),
#     DT::dataTableOutput("blaster")
#   ),
# 
#   conditionalPanel("false", icon("crosshair"))
# )


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


# navbarPage("Map my Corona", id="nav",
#            
#   fluidRow(
#    column(3,
#           selectInput("states", "States", c("All states"="", structure(state.abb, names=state.name), "Washington, DC"="DC"), multiple=TRUE)
#    ),
#    column(3,
#           conditionalPanel("input.states",
#                            selectInput("cities", "Cities", c("All cities"=""), multiple=TRUE)
#           )
#    ),
#    column(3,
#           conditionalPanel("input.states",
#                            selectInput("zipcodes", "Zipcodes", c("All zipcodes"=""), multiple=TRUE)
#           )
#    )
#   ),
# 
#   tabPanel("Interactive map",
#     div(class="outer",
# 
#       tags$head(
#         # Include our custom CSS
#         includeCSS("styles.css"),
#         includeScript("gomap.js")
#       ),
# 
#       # If not using custom CSS, set height of leafletOutput to a number instead of percent
#       #leafletOutput("map", width="100%", height="100%"),
#       leafletOutput("map"),
# 
#       # # Shiny versions prior to 0.11 should use class = "modal" instead.
#       # absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
#       #   draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
#       #   width = 330, height = "auto",
#       # 
#       #   h2("ZIP explorer"),
#       # 
#       #   selectInput("color", "Color", vars),
#       #   selectInput("size", "Size", vars, selected = "adultpop"),
#       #   conditionalPanel("input.color == 'superzip' || input.size == 'superzip'",
#       #     # Only prompt for threshold when coloring or sizing by superzip
#       #     numericInput("threshold", "SuperZIP threshold (top n percentile)", 5)
#       #   ),
#       # 
#       #   plotOutput("histCentile", height = 200),
#       #   plotOutput("scatterCollegeIncome", height = 250)
#       # ),
#       tags$div(id="cite",
#                'Data compiled for ', tags$em('Map my Corona'), ' by HDSU 2019.'
#       )
#     )
#   ),
# 
#   tabPanel("Data explorer",
#     hr(),
#     DT::dataTableOutput("blaster")
#   ),
# 
#   conditionalPanel("false", icon("crosshair"))
# )



# fluidPage(
#   
#   # App title ----
#   titlePanel("Map my Corona"),
#   
#   # Sidebar layout with input and output definitions ----
#   sidebarLayout(
#     
#     # Sidebar panel for inputs ----
#     sidebarPanel(
#       
#       
#       
#       # Input: Selector for choosing Regulatory Variance metric ----
#       selectInput(inputId = "sel_country",
#                   label = "Choose countries (default all):",
#                   choices = unique(blaster$Geo_Location),
#                   multiple = TRUE),
#       
#       # Input: Select number of colummns for the plot
#       # sliderInput(inputId = "gg_MOCA_TCGA_corr_cols", 
#       #             label = h3("Select number of trajectories to visualize side by side"), 
#       #             min = 1, max = 7, 
#       #             value = 3),
#       
#       # Input: Select only top n hits
#       sliderInput(inputId = "blaster_top_n_hits", 
#                   label = h3("Select only the top n hits from the BLASTS result"), 
#                   min = 1, max = nrow(blaster), 
#                   value = nrow(blaster)),
#       
#       
#       # Download Handler for plots
#       downloadButton('downloadPlot', 'Download plot')
#       
#     ),
#     
#     # Main panel for displaying outputs ----
#     mainPanel(
#       #DT::dataTableOutput("blaster")
#       
#       tabsetPanel(
#         tabPanel("Interactive map",
#                  div(class="outer",
# 
#                      tags$head(
#                        # Include our custom CSS
#                        includeCSS("styles.css"),
#                        includeScript("gomap.js")
#                      ),
# 
#                      # If not using custom CSS, set height of leafletOutput to a number instead of percent
#                      #leafletOutput("map", width="100%", height="100%"),
#                      leafletOutput("map"),
# 
#                      # Shiny versions prior to 0.11 should use class = "modal" instead.
#                      # absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
#                      #               draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
#                      #               width = 330, height = "auto",
#                      # 
#                      #               h2("ZIP explorer"),
#                      # 
#                      #               selectInput("color", "Color", vars),
#                      #               selectInput("size", "Size", vars, selected = "adultpop"),
#                      #               conditionalPanel("input.color == 'superzip' || input.size == 'superzip'",
#                      #                                # Only prompt for threshold when coloring or sizing by superzip
#                      #                                numericInput("threshold", "SuperZIP threshold (top n percentile)", 5)
#                      #               ),
#                      # 
#                      #               plotOutput("histCentile", height = 200),
#                      #               plotOutput("scatterCollegeIncome", height = 250)
#                      # ),
# 
#                      tags$div(id="cite",
#                               'Data compiled for ', tags$em('Map my Corona'), ' by HDSU 2019.'
#                      )
#                  )
#         ),
# 
#         tabPanel("Data explorer",
#                  hr(),
#                  DT::dataTableOutput("blaster")
#         )#,
# 
#         #conditionalPanel("false", icon("crosshair"))
#       )
# 
#       
#       
#       
#       # # Sample annotation table to select
#       # DT::DTOutput("dt"),
#       # checkboxInput("dt_sel", "sel/desel all"),
#       # #h4("selected rows:"),
#       # #verbatimTextOutput("selected_rows", TRUE),
#       # 
#       # # Output: UMAP colored by correlation to selected sample
#       # plotOutput(outputId = "gg_MOCA_TCGA_corr")
#       
#     )
#   )
# )


# 
# 
# 
# navbarPage("Map my Corona", id="nav",
#            
#            tabPanel("Interactive map",
#                     div(class="outer",
#                         
#                         tags$head(
#                           # Include our custom CSS
#                           includeCSS("styles.css"),
#                           includeScript("gomap.js")
#                         ),
#                         
#                         # If not using custom CSS, set height of leafletOutput to a number instead of percent
#                         leafletOutput("map", width="100%", height="100%"),
#                         
#                         # Shiny versions prior to 0.11 should use class = "modal" instead.
#                         absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
#                                       draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
#                                       width = 330, height = "auto",
#                                       
#                                       h2("ZIP explorer"),
#                                       
#                                       selectInput("color", "Color", vars),
#                                       selectInput("size", "Size", vars, selected = "adultpop"),
#                                       conditionalPanel("input.color == 'superzip' || input.size == 'superzip'",
#                                                        # Only prompt for threshold when coloring or sizing by superzip
#                                                        numericInput("threshold", "SuperZIP threshold (top n percentile)", 5)
#                                       ),
#                                       
#                                       plotOutput("histCentile", height = 200),
#                                       plotOutput("scatterCollegeIncome", height = 250)
#                         ),
#                         
#                         tags$div(id="cite",
#                                  'Data compiled for ', tags$em('Coming Apart: The State of White America, 1960–2010'), ' by Charles Murray (Crown Forum, 2012).'
#                         )
#                     )
#            ),
#            
#            tabPanel("Data explorer",
#                     fluidRow(
#                       column(3,
#                              selectInput("states", "States", c("All states"="", structure(state.abb, names=state.name), "Washington, DC"="DC"), multiple=TRUE)
#                       ),
#                       column(3,
#                              conditionalPanel("input.states",
#                                               selectInput("cities", "Cities", c("All cities"=""), multiple=TRUE)
#                              )
#                       ),
#                       column(3,
#                              conditionalPanel("input.states",
#                                               selectInput("zipcodes", "Zipcodes", c("All zipcodes"=""), multiple=TRUE)
#                              )
#                       )
#                     ),
#                     fluidRow(
#                       column(1,
#                              numericInput("minScore", "Min score", min=0, max=100, value=0)
#                       ),
#                       column(1,
#                              numericInput("maxScore", "Max score", min=0, max=100, value=100)
#                       )
#                     ),
#                     hr(),
#                     DT::dataTableOutput("blaster")
#            ),
#            
#            conditionalPanel("false", icon("crosshair"))
# )