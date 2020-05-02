library(dplyr)
library(networkD3)
library(magrittr)
library(igraph)


# LOADING IN EDGE DATA
bennett <- read.csv("03_data/02_citationedges.csv", stringsAsFactors = FALSE) %>% mutate(value = 2, Target = 1:n(), Source = 0)

# CREATING A NODES OBJECT
bennett_nodes <- append(unique(bennett$cited_by), unique(bennett$citing)) %>%
  as.data.frame() 

# renaming author column 
names(bennett_nodes)[1]<- "name"

# joining node attributes to nodes object
bennett_nodes %<>% left_join(bennett, by = c("name" = "citing"))

# filling in Bennett data
bennett_nodes$citecount[1] <- 1 
bennett_nodes$category[1] <- "RSP"

# adding category column with more meaningful names
bennett_nodes$category_full <- ifelse(bennett_nodes$category == "RSP", "Remote Sensing Politics",
                                      ifelse(bennett_nodes$category == "CGIS", "Critical GIS", 
                                             ifelse(bennett_nodes$category == "RSA", "Remote Sensing Application", 
                                                    ifelse(bennett_nodes$category == "RSH", "Remote Sensing History", "Science and Technology Studies"))))
                                      
p <- forceNetwork(Links = bennett, Nodes = bennett_nodes, Source = "Source", Target = "Target", Value = "value", NodeID = "name", Nodesize = "citecount", Group = "category_full", zoom = TRUE, linkDistance = 200, arrows = FALSE, legend = TRUE, fontFamily = "Avenir", fontSize = 14)

p$x$nodes$hyperlink <- lapply(bennett_nodes$title, function(x) {
  paste0("https://scholar.google.com/scholar?hl=en&as_sdt=0%2C30&q=", URLencode(x))
  })

p$x$options$clickAction <- 'window.open(d.hyperlink)'

p

# saveNetwork(p, file = "bennett_bib.html")

