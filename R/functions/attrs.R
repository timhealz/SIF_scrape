library(rvest)
library(dplyr)

attrs = function(node) {
    
    html %>%
        html_nodes(node) %>%
        html_attrs()
}

