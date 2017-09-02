library(rvest)
library(dplyr)

text = function(node) {
    
    html %>%
        html_nodes(node) %>%
        html_text()
}

