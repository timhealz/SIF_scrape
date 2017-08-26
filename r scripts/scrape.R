setwd("~/G_WD/SIF_scrape")

week_raw = "Week 1, 2017"
out_path = paste("./output/", week_raw, "/", Sys.Date(), sep = "")
dir.create(out_path)

source("./r scripts/espn_spreads.R")
source("./r scripts/oddshark_spreads.R")

espn = read.csv(
        paste(out_path, "/espn_", Sys.Date(), ".csv", sep = ""))[,c("game_id", "espn_spread")]
oddshark = read.csv(
        paste(out_path, "/oddshark_", Sys.Date(), ".csv", sep = ""))[,c("game_id", 
                                                                        "oddshark_spread",
                                                                        "update_ts")]

dat = merge(espn, oddshark, by = "game_id")

write.csv(dat, paste(out_path, "/", "Spreads_", Sys.Date(), ".csv", sep = ""))

