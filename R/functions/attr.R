library(rvest)
library(dplyr)

attr = function(node, attr) {
    
    html %>%
        html_nodes(node) %>%
        html_attr(attr)
}

