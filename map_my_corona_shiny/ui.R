library(leaflet)
library(shinydashboard)
library(shinyWidgets)
library(shinyjs)


dashboardPage(
  #----------------------------------------------------------------------------#
  #                                Header                                      #
  #----------------------------------------------------------------------------#
  dashboardHeader(
    #title = "Map my Corona",
    title = tags$a(href="https://www.hdsu.org/",
                   tags$img(src="map_my_corona_logo.png",height="50px")),
    #titleWidth = 400,
    
    # dropdownMenuOutput('messageMenu'),
    # 
    # dropdownMenu(type = 'tasks',
    #              badgeStatus = 'success',
    #              taskItem(value = 90, color = 'green', 'Documentation'),
    #              taskItem(value = 17, color = 'aqua', 'Project X'),
    #              taskItem(value = 75, color = 'yellow', 'Server deployment'),
    #              taskItem(value = 80, color = 'red', 'Overall project')
    # ),
    # 
    # dropdownMenu(type = 'notifications',
    #              notificationItem(text = '5 new users today', icon('users')),
    #              notificationItem(text = '12 items delivered',
    #                               icon('truck'), status = 'success'),
    #              notificationItem(text = 'Server load at 86%',
    #                               icon = icon('exclamation-triangle'),
    #                               status = 'warning')),
    # dropdownMenu(type = 'tasks',
    #              badgeStatus = 'success',
    #              taskItem(value = 90, color = 'green', 'Documentation'),
    #              taskItem(value = 17, color = 'aqua', 'Project X'),
    #              taskItem(value = 75, color = 'yellow', 'Server deployment'),
    #              taskItem(value = 80, color = 'red', 'Overall project')),
    
    
    tags$li(class = "dropdown",
            tags$a(href="https://www.hdsu.org/", target="_blank",
                   tags$style(".main-header {max-height: 55px}"),
                   tags$style(".main-header .logo {height: 55px}"),
                   tags$img(height = "30px", alt="SNAP Logo", src="logo_hdsu.png")
            )
    )
    
  ),
  # dashboardHeader(# Set height of dashboardHeader
  #   tags$li(class = "dropdown",
  #           tags$style(".main-header {max-height: 60px}"),
  #           tags$style(".main-header .logo {height: 60px}")
  #   ),
  #   title = tags$a(href="https://www.hdsu.org/",
  #                  tags$img(src="logo_hdsu.png",height="40")),
  #   titleWidth = 400),

  #dashboardHeader(title = "Map my Corona"),
  
  # dashboardHeader(title = 'Reporting Dashboard',
  #                 tags$li(class = "dropdown",
  #                         tags$a(href="https://www.hdsu.org/", target="_blank", 
  #                                tags$img(height = "20px", alt="SNAP Logo", src="logo_hdsu.png")
  #                         )
  #                 ),
  #                 dropdownMenuOutput('messageMenu'),
  #                 dropdownMenu(type = 'notifications',
  #                              notificationItem(text = '5 new users today', icon('users')),
  #                              notificationItem(text = '12 items delivered', 
  #                                               icon('truck'), status = 'success'),
  #                              notificationItem(text = 'Server load at 86%', 
  #                                               icon = icon('exclamation-triangle'), 
  #                                               status = 'warning')),
  #                 dropdownMenu(type = 'tasks',
  #                              badgeStatus = 'success',
  #                              taskItem(value = 90, color = 'green', 'Documentation'),
  #                              taskItem(value = 17, color = 'aqua', 'Project X'),
  #                              taskItem(value = 75, color = 'yellow', 'Server deployment'),
  #                              taskItem(value = 80, color = 'red', 'Overall project'))
  # ),
  
  #----------------------------------------------------------------------------#
  #                                Sidebar                                     #
  #----------------------------------------------------------------------------#
  dashboardSidebar(

    sidebarMenu(
      br(),
      h6("MapMyCorona is a blast-server", align = "center"),
      h6("for SARS CoV-2 sequences (protein or DNA)", align = "center"),
      h6("which displays the top hits", align = "center"),
      h6("in a spatial and temporal fashion.", align = "center"),
      tags$hr(),
      #h6("Once displayed, you can filter the results by date or country.", align = "center"),
      
      
      
      # menuItem(
      #   "Multiple Incident Analysis",
      #   tabName = "dashboard",
      #   icon = icon("th")),      
      # div(id = "mult", splitLayout(cellWidths = c("44%", "31%", "25%"),
      #                              dateInput("datefrom", "Date From:", format = "mm/dd/yyyy", Sys.Date()-5),
      #                              textInput("datefrom_hour", "Hour",
      #                                        value = "12:00"),
      #                              textInput("datefrom_noon","AM/PM", value = "AM")),      
      #     splitLayout(cellWidths = c("44%", "31%", "25%"),
      #                 dateInput("dateto", "Date To:", format = "mm/dd/yyyy"),
      #                 textInput("dateto_hour", "Hour",
      #                           value = "11:59"),
      #                 textInput("dateto_noon","AM/PM", value = "PM"))
      # ),
      # menuItem("Single Analysis", 
      #          tabName = "widgets", 
      #          icon = icon("th")
      # ),
      # div(id = "single", style="display: none;", numericInput("tckt", "Ticket Number : ", 12345,  width = 290)),
      # submitButton("Submit", width = "290"),
      # Horizontal line ----
      
      h4("Search sequence", align = "center"),
      h6("from Fasta or from search box", align = "center"),
      
      menuItem(
        "Search ...",
        tabName = "searchseq",
        icon = icon("search"),
        startExpanded = TRUE,
        
        # Input: Select a file ----
        fileInput("file1", "Choose Fasta File",
                  multiple = FALSE,
                  accept = c(".RDS", ".fa", ".fasta")),
        
        # Search fasta sequence
        textAreaInput("stringSequence", "Search sequence...", "> my_corona"),
        actionBttn(
          inputId = "clear_stringSequence",
          label = "Clear", 
          style = "minimal",
          size = "xs",
          color = "default"
        ),
        
        awesomeRadio(
          inputId = "seq_type",
          label = "Sequence Type",
          choices = c("nucleotide", "protein"),
          selected = "nucleotide",
        ),
        
        menuItem(
          "BLAST options",
          tabName = "blastopt",
          #icon = icon("user-secret")
          icon = icon("cog"),
          
          numericInput(
            inputId = "blast_nres", 
            label = "Number of results:", 
            value = 500,
            min = 1, 
            max = NA, 
            step = NA, 
            width = "90%"),
          
          numericInput(
            inputId = "blast_evalt", 
            label = "Expectation value (E) threshold:", 
            value = 1000,
            min = 0.001, 
            max = NA, 
            step = NA, 
            width = "90%"),
          
          sliderTextInput(
            inputId = "blast_pident_range",
            label = "Percent identity (pident) :", 
            choices = seq(0, 100, 10),
            selected = c(0, 100),
            from_min = 0,
            from_max = 100,
            grid = TRUE
          )
          
        ),
        
        
        actionBttn(
          inputId = "searchSequence",
          label = "Submit",
          style = "jelly",
          size  = "sm",
          color = "danger"
        ),
        h6("Click Submit without any input", align = "center"),
        h6("to display results for MT188340 (nucleotide)", align = "center"),
        h6("or QHN73805 (protein)", align = "center"),
        br()
      ),
      
      tags$hr(),
      
      
      menuItem(
        "Map",
        tabName = "maps",
        icon = icon("globe")
      ),

      menuItem(
        "Data explorer",
        tabName = "dataexplore",
        icon = icon("bar-chart")
      ),
      
      
      menuItem(
        "Options",
        tabName = "options",
        #icon = icon("bars"),
        icon = icon("cogs"),
        
        awesomeRadio(
          inputId = "score_id",
          label = "Select score metric",
          choices = c("Percent identity", "evalue", "bitscore"),
          selected = "Percent identity",
        ),
        
        
        selectInput(
          inputId  = "sel_area_col",
          label    = "Color Area By:",
          choices  = unname(color_area_IDs),
          selected = unname(color_area_IDs)[1],
          multiple = FALSE
        )
        
      ),
      
      menuItem(
        "FAQ",
        tabName = "faq",
        #icon = icon("user-secret")
        icon = icon("question-circle")
      ),

      
      #br(),
      tags$hr()

      # h4("Options", align = "center"),
      # h5("Placeh", align = "center")
      #h6("from Fasta or from search box", align = "center"),
      
    )
  ),

  #----------------------------------------------------------------------------#
  #                              dashboardBody                                 #
  #----------------------------------------------------------------------------#
  dashboardBody(
    useShinyjs(),
    tags$head(
      tags$style(
        HTML(".shiny-notification {
             position:fixed;
             top: calc(50%);
             left: calc(50%);
             }
             "
        )
      )
    ),
    
    tabItems(
      tabItem(
        tabName = "faq",
        fluidRow(
          box(
            title = "Description", width = NULL, background = "black",
            "MapMyCorona is a blast-server for SARS CoV-2 sequences (protein or DNA) which displays the top hits in a spatial and temporal fashion.",
            "Once displayed, you can filter the results by date or country."
          ),
          
          box(
            title = "BLAST Options", width = NULL, background = "light-blue",
            "A box with a solid light-blue background"
          )
          
        ),
        
        fluidRow(
          tags$style(type = "text/css", "#map {height: calc(100vh - 80px) !important;}"),
          box(
            #height = 300,
            width = 12,
            leafletOutput("empty_map"),
            "Empty box"
          )
        )
      ),

      tabItem(
        tabName = "maps",
        fluidRow(
          # dropdownButton(
          #   
          #   tags$h3("List of Inputs"),
          #   
          #   selectInput(inputId = 'xcol',
          #               label = 'X Variable',
          #               choices = names(iris)),
          #   
          #   selectInput(inputId = 'ycol',
          #               label = 'Y Variable',
          #               choices = names(iris),
          #               selected = names(iris)[[2]]),
          #   
          #   sliderInput(inputId = 'clusters',
          #               label = 'Cluster count',
          #               value = 3,
          #               min = 1,
          #               max = 9),
          #   
          #   circle = TRUE, status = "danger",
          #   icon = icon("gear"), width = "300px",
          #   
          #   tooltip = tooltipOptions(title = "Click to see inputs !")
          # ),
          
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
            uiOutput("date_range"),
            
            
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

      tabItem(
        tabName = "dataexplore",
        div(style = 'overflow-x: scroll',
            #DT::DTOutput("blaster"))
            #checkboxInput("dt_sel", "sel/desel all")
            DT::dataTableOutput('blaster_ui'))
        #DT::dataTableOutput("blaster")
      )

    )
  ),
  skin = "black"
)



# 
# dashboardPage(
#   
#   dashboardHeader(title = "Map my Corona"),
#   #----------------------------------------------------------------------------#
#   #                                Sidebar                                     #
#   #----------------------------------------------------------------------------#
#   dashboardSidebar(
#     
#     sidebarMenu(
#       
#       menuItem(
#         "Map", 
#         tabName = "maps", 
#         icon = icon("globe")
#       ),
#       
#       menuItem(
#         "Data explorer", 
#         tabName = "dataexplore", 
#         icon = icon("bar-chart")
#       ),
#       
#       # Horizontal line ----
#       tags$hr(),
#       h4("Search sequence", align = "center"),
#       h6("from Fasta or from search box", align = "center"),
#       
#       # Input: Select a file ----
#       fileInput("file1", "Choose Fasta File",
#                 multiple = FALSE,
#                 accept = c(".RDS", ".fa", ".fasta")),
#       
#       # Search fasta sequence
#       textAreaInput("stringSequence", "Search sequence...", "> my_corona\natatataaccddf"),
#       
#       actionBttn(
#         inputId = "searchSequence",
#         label = "Submit",
#         style = "jelly", 
#         size  = "sm",
#         color = "danger"
#       ),
#       h6("Click Submit without any input", align = "center"),
#       h6("to display results for MT188340", align = "center"),
#       
#       
#       br(),
#       tags$hr(),
#       h4("Options", align = "center"),
#       #h6("from Fasta or from search box", align = "center"),
#       
#       awesomeRadio(
#         inputId = "score_id",
#         label = "Select score metric", 
#         choices = c("Percent identity", "evalue", "bitscore"),
#         selected = "Percent identity",
#       ),
#       
#       
#       selectInput(
#         inputId  = "sel_area_col",
#         label    = "Color Area By:",
#         choices  = unname(color_area_IDs),
#         selected = unname(color_area_IDs)[1],
#         multiple = FALSE
#       )
#       
#       
#     )
#   ),
#   
#   #----------------------------------------------------------------------------#
#   #                              dashboardBody                                 #
#   #----------------------------------------------------------------------------#
#   dashboardBody(
#     useShinyjs(),
#     tabItems(
#       
#       
#       tabItem(
#         tabName = "maps",
#         fluidRow(
#           box(
#             height = 100, 
#             width = 4, 
#             background = "black",
#             plotOutput(outputId = "gg_data_months")
#           ),
#           
#           box(
#             height = 100, 
#             width = 4, 
#             background = "black",
#             uiOutput("date_range")
#           ),
#           
#           box(
#             height = 100,
#             width = 4, 
#             background = "black",
#             # Input: Selector for choosing Regulatory Variance metric ----
#             uiOutput("sel_country")
#           )
#           
#         ),
#         
#         fluidRow(
#           tags$style(type = "text/css", "#map {height: calc(100vh - 80px) !important;}"),
#           box(
#             #height = 300,
#             width = 12, 
#             leafletOutput("map")
#           )
#         )
#       ),
#       
#       tabItem(
#         tabName = "dataexplore",
#         
#         fluidRow(
#           box(
#             height = 100, 
#             width = 4, 
#             background = "black",
#             plotOutput(outputId = "gg_data_months")
#           ),
#           
#           box(
#             height = 100, 
#             width = 4, 
#             background = "black",
#             uiOutput("date_range")
#           ),
#           
#           box(
#             height = 100,
#             width = 4, 
#             background = "black",
#             # Input: Selector for choosing Regulatory Variance metric ----
#             uiOutput("sel_country")
#           )
#           
#         ),
#         fluidRow(
#           div(style = 'overflow-x: scroll', 
#               #DT::DTOutput("blaster"))
#               #checkboxInput("dt_sel", "sel/desel all")
#               DT::dataTableOutput('blaster_ui'))
#         )
#         
#       )
#       
#     )
#   ), 
#   skin = "black"
# )


