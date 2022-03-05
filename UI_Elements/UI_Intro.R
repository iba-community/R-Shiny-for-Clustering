## Creates body of dashboard 

## Tab Items
# 
PurposeDesc <- "Self-Organizing Maps are a form of neural networks that help analyze
                and map the topology of high-dimensional data. The purpose of this web
                app is to help the user view clusters within their data and to get an 
                image of their data."



intro_tab_item <- tabItem(tabName = "Introduction", 
                          box(title = "Purpose", status = "info", width = 12, PurposeDesc, 
                              tags$img(src="som.gif", align = "center",height='300px',width='500px'),
                              br(), 
                              em("Figure 1. Animated GIF showing how a SOM grid evolves to take the shape of our data. 
                                 Note that the visualization is a top-down view of the data, and the neurons 
                                 are actually moving in three dimensions(1)")),
                          
                          box(title = "Directions", status = "info", width = 12, 
                              p("1. Upload your data to the 'Import Data' tab"),   
                              p("2. Go to the 'Visualize Data' tab to view your plot"), 
                              p("* If you would like more configuration options then press the 'Advanced' button")),
                          
                          box(title = "Counts Plot", status = "info", width = 4,
                              tags$img(src = "counts.png", align = "left", height = 90, width = 90),
                              em("The Counts Plot gives a heatmap to help visualize how many data points each cell (circle) contains(2)")), 
                          
                          box(title = "Neighbourhood Distance Plot", status = "info", width = 4,
                              tags$img(src = "ndistance.png", align = "left", height = 90, width = 90),
                              em("The Neighborhood Distance plot gives the overall distance between each node(2)")),
                          
                          box(title = "Codes Plot", status = "info", width = 4,
                              tags$img(src = "codes.png", height = 90, width = 90),
                              em("The Codes plot gives pie-like representations of what kind of data each grid cell holds(2)")),
                          
                          box(title = "Citations", status = "info", width = 12,
                              p("1. https://algobeans.com/2017/11/02/self-organizing-map/"), 
                              p("2. https://clarkdatalabs.github.io/soms/SOM_NBA"))
                          
                          
)
# 
import_tab_item <- tabItem(tabName = "Import",
                           box(title = "Upload Dataset", status = "primary", width = 12,
                               fileInput("file", "Enter CSV file"))
)
# 
config_tab_item <- tabItem(tabName = "Configuration",
                           box(title = "Settings", status = "primary", width = 12,
                               uiOutput("columns"),
                               uiOutput("size"),
                               textInput("name", "Enter the title of the plot", placeholder = "SOM Plot"))
)
# 
visual_tab_item <- tabItem(tabName = "Visual",
                           box(title = "SOM Plot", status = "primary", width = 12,
                               plotOutput("som"))
)

## Create Body
body <- dashboardBody(
  tabItems(
    intro_tab_item,
    import_tab_item,
    config_tab_item,
    visual_tab_item
  )
)