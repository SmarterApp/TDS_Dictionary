// this allows Flash to be disabled (it has to be set as early as possible..)
soundManager.audioFormats.mp3.required = false;
var smRebooted = false;

function smInit() {

    var flashPath = 'Scripts/Libraries/soundmanager2/swf/';

    soundManager.setup({
        url: flashPath,
        flashVersion: 9, // plays more modern audio
        preferFlash: false, // setting this to false prefers HTML5
        useHTML5Audio: true // the default is true but just to be clear
    });

    // this gets fired when SM has loaded
    soundManager.ontimeout(function() {
        if (!smRebooted) {
            smRebooted = true;
            setTimeout(function() {
                soundManager.reboot();
            }, 1000);
        }
    });

}

function doSoundClick(event) {
    var $link = $(this);
    var filelink = $link.attr('href');
    var fileLang = $link.data('language');
    playFileLink(filelink,fileLang);
    event.preventDefault();
}

//rules from here http://www.dictionaryapi.com/info/faq-audio-image.htm#collegiate
function getFileLinkIndex(filelink) {
    if (filelink.substr(0, 3) == 'bix') {
        return 'bix';
    } else if (filelink.substr(0, 2) == 'gg') {
        return 'gg';
    } else if (filelink.match(/^[0-9]+.+$/)) {
        //starts with a number
        return 'number';
    } else {
        return filelink.substr(0, 1);
    }
}

function getModifiedFileLink(filelink, newExt) {
    var extIdx = filelink.indexOf('.');
    return filelink.substr(0, extIdx + 1) + newExt;
}

// Collection of all known mime types (http://diveintohtml5.info/everything.html)
// NOTE: We only support wav and ogg right now with MW
var MIME_TYPES = {
    'ogg': 'audio/ogg; codecs="vorbis"',
    'wav': 'audio/wav; codecs="1"',
    'mp4': 'audio/mp4; codecs="mp4a.40.2"',
    'mp3': 'audio/mpeg;'
};

// get the mime type for a file extension (e.x., 'wav')
function getMimeType(ext) {
    return MIME_TYPES[ext];
}

// check if this browser can play a file extension (e.x., 'ogg')
function canPlayAudioExt(ext) {
    var type = getMimeType(ext);
    return (type && soundManager.canPlayMIME(type));
}

// get the file extension the browser supports
function getSupportedAudioExt() {
    if (navigator.userAgent.match(/(iPod|iPhone|iPad)/)){
        return null;
    }

    var allowedExts = ['ogg', 'wav'];

    for (var i = 0; i < allowedExts.length; i++) {
        var ext = allowedExts[i];
        if (canPlayAudioExt(ext)) {
            return ext;
        }
    }

    return null;
}

function playFileLink(filelink, fileLang) {
    //check for audio conflicts with parent window
    if (window.parent.TDS && window.parent.TDS.Audio && window.parent.TDS.Audio.isActive && window.parent.TDS.Audio.isActive()) {
        return;
    }
    if(window.parent.TTS && window.parent.TTS.Manager && window.parent.TTS.Manager.getStatus && window.parent.TTS.Manager.getStatus() == 'Playing'){
        return;
    }

    // get the url index
    var fileIndex = getFileLinkIndex(filelink);

    // get the file link
    var fileExt = getSupportedAudioExt();
    if (!fileExt) {
        return;
    }

    // get modified file based on extension 
    filelink = getModifiedFileLink(filelink, fileExt);

    // var url = 'http://upload.wikimedia.org/wikipedia/commons/c/c8/Example.ogg';
    // var url = 'http://media.merriam-webster.com/soundc11/' + fileIndex + '/' + filelink;
    var url = 'http://media.merriam-webster.com/audio/prons/' + fileLang + fileExt + '/' + fileIndex + '/' + filelink;


    var snd = soundManager.createSound({
        id: 'snd_' + filelink,
        url: url,
        type: getMimeType(fileExt),
        onload: function(success) {
            console.log('sound onload: ' + success);
        },
        onplay: function() {
            console.log('sound onplay');
        },
        onstop: function() {
            console.log('sound onstop');
        },
        onfinish: function() {
            console.log('sound onfinish');
        }
    });

    // try and stop if we are playing
    if (snd.playState > 0) {
        snd.stop();
    }

    // play audio link
    snd.play();
}

$(document).ready(function() {

    smInit();

    // listen for clicks on audio links
    $('body').on('click', 'a.au', doSoundClick);

    // check if audio on this browser is supported
    soundManager.onready(function() {
        if (getSupportedAudioExt() == null) {
            $('body').removeClass('TDS_DO_SL');
        }
    });
});