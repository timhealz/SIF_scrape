setwd("~/G_WD/SIF_scrape")
source("./R/functions/text.R")
source("./R/functions/attr.R")
map = read.csv("map.csv", stringsAsFactors = FALSE, header = TRUE)[,1:2]

html = read_html('./espn.html')
egame_id = as.integer(na.omit(attr(".scoreboard", "id")))
teams = text('.sb-team-short')
away = teams[c(TRUE,FALSE)]
home = teams[c(FALSE,TRUE)]

time = character()

for(i in egame_id){
    
    times = text(paste("#", i,  " .time", sep = ""))
    time = append(time, times)

}

games = as.data.frame(cbind(egame_id, away, home, time),stringsAsFactors = FALSE)

games$time = gsub("ET", "", games$time)
games$time = substr(strptime(games$time, "%I:%M %p" ),11,19)

games = merge(map, games, by = "egame_id", all.y = TRUE)
games = games[order(games$game_id),]

write.csv(games, "./output/espn_times.csv", row.names = FALSE)