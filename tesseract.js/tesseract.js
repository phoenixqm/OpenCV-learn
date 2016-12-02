var tesseract = require('node-tesseract');

var options1 = {
    l: 'eng',
    psm: 6,
    binary: '/usr/local/bin/tesseract'
};

// Recognize text of any language in any format
tesseract.process(__dirname + '/1.png', options1, function(err, text) {
    if(err) {
        console.error(err);
    } else {
        console.log(text);
    }
});

// Recognize German text in a single uniform block of text and set the binary path

var options = {
    l: 'eng',
    psm: 6,
    binary: '/usr/local/bin/tesseract'
};

tesseract.process(__dirname + '/2.png', options, function(err, text) {
    if(err) {
        console.error(err);
    } else {
        console.log(text);
    }
});

