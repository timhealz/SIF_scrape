library(rvest)
library(plyr)
library(stringr)

setwd("~/G_WD/SIF_scrape")

system("./phantomjs scrape_oddshark.js")

html = read_html('oddsshark.html')

trim <- function (x) gsub("^\\s+|\\s+$", "", x)

teams = html %>%
    html_nodes(".teams") %>%
    html_text()
teams = trim(teams)
teams = str_split_fixed(teams, " ", 2)

lines = html %>%
    html_nodes(".lines") %>%
    html_text()
lines = trim(lines)
lines = str_split_fixed(lines, " ", 2)

spreads = as.data.frame(cbind(teams, lines))
colnames(spreads) = c("away", "home", "away_spread", "home_spread")
spreads$timestamp = Sys.time()

write.csv(spreads, paste("./output/Spreads_", Sys.Date(),".csv", sep = ""), row.names = FALSE)
