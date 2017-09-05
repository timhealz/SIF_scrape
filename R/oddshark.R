###############################################################################################
#                                           Spreads                                           #
###############################################################################################

# setting working directories, loading libraries/functions and creating output folder
setwd("~/G_WD/SIF_scrape")
library(stringr)
source("./R/functions/text.R")
source("./R/functions/attr.R")
source("./R/functions/attrs.R")
out_path = paste("./output/", Sys.Date(), sep = "")

# run phantomjs file to render javascript, save and read html
# read table that maps espn game ids to our game ids
print("running oddshark phantom js...")
    
    system("./phantomjs scrape_oddshark.js")
    html = read_html('./oddshark.html')
    
    map = read.csv('map.csv', header = TRUE, stringsAsFactors = FALSE)

print("COMPLETE")

# scrape oddshark teams and spreads
print("scraping oddshark teams & spreads...")

    # scrape cities and teams
    teams = text('.city')
    lines = text('.value')

print("COMPLETE")

# parsing teams into games
print("parsing teams into games...")
spreads = as.data.frame(cbind(
                    away = teams[c(TRUE, FALSE)], 
                    home = teams[c(FALSE, TRUE)],
                    oddshark_spread = lines[c(TRUE,FALSE)]
                    ),
                stringsAsFactors = FALSE,
                row.names = FALSE)
spreads$oddshark_spread = abs(as.numeric(spreads$oddshark_spread))
spreads$matchup = paste(spreads$away, spreads$home, sep = '')

print("COMPLETE")

# cleaning data, timestamping, and writing .csv
print("cleaning data, timestamping, and writing .csv...")

    spreads = merge(map[,c('game_id', 'matchup')], 
                    spreads[,c('matchup', 'oddshark_spread')], 
                    by = 'matchup', all.y = TRUE)
    spreads = spreads[complete.cases(spreads),][,2:3]
    spreads = spreads[order(spreads$game_id),]
    spreads$update.ts = Sys.time()
    
    write.csv(spreads, 
              paste(out_path,"/oddshark.csv", sep = ""), 
              row.names = FALSE)

print("COMPLETE")

