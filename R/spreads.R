setwd("~/G_WD/SIF_scrape2")
out_path = paste("./output/", Sys.Date(), sep = '')
source("./R/espn.R")
source("./R/oddshark.R")
source("./R/scores.R")

setwd(out_path)

espn_spreads = read.csv('espn.csv', stringsAsFactors = FALSE)
oddshark_spreads = read.csv('oddshark.csv', stringsAsFactors = FALSE)

dat = merge(espn_spreads, oddshark_spreads, by = 'game_id', all = TRUE)
write.csv(dat, "spreads.csv", row.names = FALSE)

