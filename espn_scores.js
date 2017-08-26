var url ='http://www.espn.com/college-football/scoreboard/_/group/80/year/2016/seasontype/2/week/1';
var page = new WebPage()
var fs = require('fs');


page.open(url, function (status) {
        just_wait();
});

function just_wait() {
    setTimeout(function() {
               fs.write('espn_scores.html', page.content, 'w');
            phantom.exit();
    }, 7000);
}
