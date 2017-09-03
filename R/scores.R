###############################################################################################
#                                           Scores                                            #
###############################################################################################

setwd("~/G_WD/SIF_scrape")
library(stringr)
source("./R/functions/attr.R")
source("./R/functions/textx.R")
out_path = paste("./output/", Sys.Date(), sep = '')

html = read_html('./espn.html')
egame_id = as.integer(na.omit(attr(".scoreboard", "id")))

dat = character()

for(i in egame_id) {
    url  = paste("http://www.espn.com/college-football/game?gameId=", i, sep = "")
    
    html = read_html(url)
    
    line = textx('//*[@id="gamepackage-game-information"]/article/div/div[2]/div[1]/ul/li[1]')
    line = gsub("Line: ", "", line)
    away_team = textx('//*[@id="linescore"]/tbody/tr[1]/td[1]')
    home_team = textx('//*[@id="linescore"]/tbody/tr[2]/td[1]')
    away_score = as.numeric(textx('//*[@id="linescore"]/tbody/tr[1]/td[6]'))
    home_score = as.numeric(textx('//*[@id="linescore"]/tbody/tr[2]/td[6]'))
    status = textx('//*[@id="gamepackage-matchup-wrap"]/header/div/div[2]/span')
    
    iter = paste(i, away_team, away_score, home_team, home_score, line, status)
    dat = append(dat, iter)
    
    print(iter)
}

scores = as.data.frame(str_split_fixed(dat, " ", 8), stringsAsFactors = FALSE)
colnames(scores) = c("egame_id", "away_team", "away_score", "home_team", "home_score", 
                     "favorite", "final_spread", "status")
scores[,c("away_score", "home_score", "final_spread")] = lapply(
                            scores[,c("away_score", "home_score", "final_spread")], as.numeric)
scores$final_spread = abs(scores$final_spread)
scores = subset(scores, grepl("Final", scores$status))

scores$winner = ifelse(scores$away_score > scores$home_score, scores$away_team, scores$home_team)
scores$is.upset = as.numeric(scores$winner != scores$favorite)
scores$update.ts = Sys.time()

map = read.csv('map1.csv', header = TRUE, stringsAsFactors = FALSE)
scores = merge(map[,1:2], scores, by = "egame_id")
upsets = subset(scores, scores$is.upset == TRUE)

write.csv(scores, paste(out_path, "/scores.csv", sep = ""), row.names = FALSE)
write.csv(upsets, paste(out_path, "/upsets.csv", sep = ""), row.names = FALSE)
