library(kohonen)
library(RColorBrewer)

# Colors to be used in Class Representation Maps
QUAL_COL_PALS = brewer.pal.info[brewer.pal.info$category == 'qual',]
COLORS <- unlist(mapply(brewer.pal, QUAL_COL_PALS$maxcolors, rownames(QUAL_COL_PALS)))

# Creates a SOM object
create_SOM <- function(input, length, width, toroidal) {
  set.seed(Sys.time())
  som.grid <- somgrid(xdim = width, ydim = length, topo = 'hexagonal', toroidal = toroidal)
  som.model <- som(data.matrix(input), grid = som.grid)
  return(som.model)
}

# Displays a given SOM object on a 2D Plot
display_mapping_plot <- function(som_model, type, title, clusters = NULL, labels = NULL) {
  # Makes sure that you get the same plot for the same SOM model each time
  set.seed(2021)
  # Constants
  TYPE <- "mapping"
  SHAPE <- "straight"
  # Shows legend if given valid labels
  legend <- F
  legend_text <- F
  fill_colors <- F
  
  # Check type
  if (type == "continuous") {
    # Set plot arguments
    colors <- get_color(som_model)
    keepMargins <- F
    col <- NA
  } else if (type == "class") {
    # Set plot arguments
    colors <- NULL
    col <- NA
    keepMargins <- F
    if(!is.null(labels)) {
      # Get labels
      unlisted_labels <- unlist(labels)
      # Checks to see if labels are not numbers
      if(!is.numeric(unlisted_labels)) {
        # Get Colors
        class_colors <- c("gray", COLORS)
        # Turn Labels into numbers
        numeric_labels <- as.numeric(unlisted_labels)
        # Get colors for each node based on numeric labels
        colors <- class_colors[get_bgcol_num(som_model, numeric_labels)]
        # Legend
        legend <- T
        legend_text <- c("None", strsplit(toString(unique(unlisted_labels)), ", ")[[1]])
        fill_colors <- class_colors[1:length(legend_text)]
      }
    }
  } else {
    # Set plot arguments
    colors <- NULL
    keepMargins <- T
    col <- T
    if(!is.null(labels)) {
      # Unlist the given labels
      unlisted_labels <- unlist(labels)
      # Checks to see if labels are not numbers
      if(!is.numeric(unlisted_labels)) {
        # Get numeric values for labels
        map_labels <- as.numeric(unlisted_labels)
        color_labels <- COLORS[map_labels]
        col <- color_labels
        # Legend
        legend <- T
        legend_text <- unique(unlisted_labels)
        fill_colors <- COLORS[1:length(unique(unlisted_labels))]
      }
    }
  }
  
  # Plot SOM
  plot(som_model,
       type = TYPE,
       bg = colors,
       shape = SHAPE,
       keepMargins = keepMargins,
       col = col,
       main = title)
  
  # Show legend
  if (legend) {
    legend(x = "right", legend = legend_text, fill = fill_colors)
  }
  
  # Show Clusters
  if (!is.null(clusters)) {
    som_hc <- cutree(hclust(object.distances(som_model, "codes")), clusters);
    add.cluster.boundaries(som_model, som_hc); # Puts clusters on plot
  }
}

display_analysis_plot <- function(som_model, type, clusters = NULL, title = NULL){
  # Makes sure that you get the same plot for the same SOM model each time
  set.seed(2021)
  # Plot
  plot(som_model,
       type = type,
       main = title)
  if (!is.null(clusters)) {
    som_hc <- cutree(hclust(object.distances(som_model, "codes")), clusters);
    add.cluster.boundaries(som_model, som_hc);
  }
}

## Helper Functions

# Returns a list of colors that correspond to the weight vectors of the given SOM
get_color <- function(som_model) {
  ## extract some data to make it easier to use
  som.events <- som_model$codes[[1]]
  # Get Distance Matrix
  som.dist <- as.matrix(dist(som.events))
  # Get data scaled down to a lower dimension
  fit <- cmdscale(som.dist, eig = TRUE, k = 3)
  fit_points <- fit$points
  # Get colors
  rgb_vect <- (fit_points-min(fit_points))/(max(fit_points)-min(fit_points))
  colors <- rgb(rgb_vect)
  return(colors)
}

# Returns a list of numbers that correspond to background color
get_bgcol_num <- function(som, numeric_labels) {
  # Get Nodes
  winner_nodes <- som$unit.classif
  num_nodes <- max(winner_nodes)
  num_labels <- length(unique(numeric_labels))
  counts <- matrix(0, nrow = num_nodes, ncol = num_labels)
  # Count the number of each type of data in each node
  for (n in 1:length(winner_nodes)) {
    node <- winner_nodes[n]
    label <- numeric_labels[n]
    counts[node, label] <- counts[node, label] + 1
  }
  
  # Set background color of each node based on 
  # which type of data shows up the most
  bgcol_num <- rep(0, num_nodes)
  for (node in 1:num_nodes) {
    sub_counts <- counts[node,]
    bgcol_num[node] <- if(sum(sub_counts) != 0) which.max(sub_counts) + 1 else 1
  }
  
  return(bgcol_num)
}
