###############################################################################################
#                                           Spreads                                           #
###############################################################################################

# setting working directories, loading libraries/functions and creating output folder
setwd("~/G_WD/SIF_scrape")
library(stringr)
source("./R/functions/text.R")
source("./R/functions/attr.R")
source("./R/functions/attrs.R")
out_path = paste("./output/",Sys.Date(), sep = "")
dir.create(out_path, showWarnings = FALSE)

# run phantomjs file to render javascript, save and read html
# read table that maps espn game ids to our game ids

print("running espn phantom js...")

    system("./phantomjs scrape_espn.js")
    html = read_html('./espn.html')
    
    map = read.csv('map1.csv', header = TRUE, stringsAsFactors = FALSE)

print("COMPLETE")

# scrape espn game ids
print("scraping espn game ids, dates and times...")

    egame_id = as.integer(na.omit(attr(".scoreboard", "id")))
    
    # scrape dates and times
    dates = na.omit(attr(".date-time", "data-date"))
    dates = as.POSIXct(substr(dates, 0, 10))
    times = text(".time")

print("COMPLETE")

# loop to scrape lines and favorites
print("scrape loop to pull lines and favorites...")
    lines = character(0)
    
    for(i in egame_id){
        line = text(paste("#", i,  " .line", sep = ""))
        line = paste(i, line, sep = " ")
        
        lines = append(lines, line)
    }
    
    lines = as.data.frame(str_split_fixed(lines, " ", 3),
                          stringsAsFactors = FALSE,
                          row.names = FALSE)
    colnames(lines) = c("egame_id", "favorite", "espn_spread")
    lines$espn_spread = abs(as.numeric(lines$espn_spread))
    
    lines = lines[complete.cases(lines),]
    lines = merge(map[,1:2], lines, by = "egame_id")
    lines = lines[order(lines$game_id),]

    write.csv(lines, paste(out_path,"/espn.csv", sep = ""), row.names = FALSE)
    
print("COMPLETE")
