library(rvest)
library(dplyr)

attr = function(node, attr) {
    
    egame_id = html %>%
        html_nodes(node) %>%
        html_attr(attr)
}

