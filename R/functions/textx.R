library(rvest)
library(dplyr)

textx = function(node) {
    
    html %>%
        html_nodes(xpath = node) %>%
        html_text()
}

