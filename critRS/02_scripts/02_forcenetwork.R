library(dplyr)
library(networkD3)
library(magrittr)
library(igraph)


# loading in edge data 
bennett <- read.csv("03_data/02_citationedges.csv", stringsAsFactors = FALSE) %>% mutate(value = 2, Target = 1:n(), Source = 0)

Encoding(bennett$citing) <- "UTF-8"
Encoding(bennett$title) <- "UTF-8"

test <- iconv(bennett$citing, from = "latin1", to = "UTF-8")
test
Encoding(test) <- "UTF-8"

x <- c("Ekstr\xf8m", "J\xf6reskog", "bi\xdfchen Z\xfcrcher")
Encoding(x) <- "ISO_8859-1"
x
bennett_nodes <- append(unique(bennett$cited_by), unique(bennett$citing)) %>%
  as.data.frame() 
#%>%
 # mutate(nodeID = 0:(n()-1))

names(bennett_nodes)[1]<- "name"
bennett_nodes %<>% left_join(bennett, by = c("name" = "citing"))
bennett_nodes$citecount[1] <- 1
bennett_nodes$category[1] <- "RSP"


p <- forceNetwork(Links = bennett, Nodes = bennett_nodes, Source = "Source", Target = "Target", Value = "value", NodeID = "name", Nodesize = "citecount", Group = "category", zoom = TRUE, linkDistance = 200, arrows = FALSE, legend = TRUE)

p$x$nodes$hyperlink <- paste0("https://scholar.google.com/scholar?hl=en&as_sdt=0%2C30&q=", URLencode(bennett$title))

?forceNetwork