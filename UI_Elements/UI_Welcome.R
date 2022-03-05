## Creates the UI elements for the Welcome Page

welcome_box <- box(
  title = h1("Self-Organizing Map Creator"), background = "light-blue", width = 12, br(), 
  h4("Can be used to"), 
  HTML("<h4><ul><li>Classify</li><li>Cluster</li><li>and Visualize</li></ul></h4>"),
  h4("High dimensional data...")
)

developer_panels <- fluidRow(
  box(
    title = "Joshua Walsh", width = 4, solidHeader = TRUE, status = "info"
  ),
  box(
    title = "Zury Marroquin", width = 4, solidHeader = TRUE, status = "info"
  ),
  box(
    title = "Trenton Wesley", width = 4, solidHeader = TRUE, status = "info"
  )
)

# Shows Import options
welcome_tab_item <- tabItem(tabName = "Welcome",
                            welcome_box,
                            h2("Developers"),
                            developer_panels
)