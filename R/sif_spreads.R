setwd("~/G_WD/SIF_scrape")
out_path = paste("./output/", Sys.Date(), sep = '')
source("./R/espn.R")
source("./R/oddshark.R")

setwd(out_path)

espn_spreads = read.csv('espn.csv', stringsAsFactors = FALSE)
oddshark_spreads = read.csv('oddshark.csv', stringsAsFactors = FALSE)[,2:3]
oddshark_spreads = oddshark_spreads[complete.cases(oddshark_spreads),]

dat = merge(espn_spreads, oddshark_spreads, by = 'game_id', all = TRUE)
dat$spread = ifelse(is.na(dat$espn_spread), dat$oddshark_spread, dat$espn_spread)
dat$egame_id = NULL
dat$update.ts = Sys.time()

spreads = subset(dat, !is.na(dat$spread))
nos = subset(dat, is.na(dat$spread))

write.csv(dat, "all.csv", row.names = FALSE)
write.csv(spreads, "spreads.csv", row.names = FALSE)
write.csv(nos, "no_spreads.csv", row.names = FALSE)

print(paste("Week 2 Games:", length(egame_id)))
print(paste("Spreads Pulled:", nrow(spreads)))
print(paste("Spreads Missing:", nrow(nos)))
