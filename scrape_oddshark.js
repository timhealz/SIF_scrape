var url ='http://www.oddsshark.com/ncaaf/scores';
var page = new WebPage()
var fs = require('fs');


page.open(url, function (status) {
        just_wait();
});

function just_wait() {
    setTimeout(function() {
               fs.write('oddshark.html', page.content, 'w');
            phantom.exit();
    }, 2500);
}