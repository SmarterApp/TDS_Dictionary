// fix missing console
(function () {
    if (typeof window.console != 'object') {
        window.console = {
            log: function () { },
            error: function () { },
            warn: function () { },
            info: function () { },
            dir: function () { }
        };
    }
})();

var search_type;

//utilities
function defaultVal(v, def) {
    v = typeof v !== 'undefined' ? v : def;
    return v;
}

$.fn.enterKey = function(fnc){
    return this.each(function(){
        $(this).keypress(function(ev){
            var keycode = (ev.keyCode ? ev.keyCode : ev.which);
            if (keycode == '13'){
                fnc.call(this, ev);
            }
        });
    });
};

var search_type,
    methodCall = {
        'dictionary': 'get_definitions',
        'spanish': 'get_spanish',
        'thesaurus':'get_thesaurus'
    };

function getSearchType() {
    var searchTypes = [];
    if (selected_dict != '' && selected_dict != 'TDS_Dict0') {
        searchTypes.push('dictionary');
    } 
    if (query_accoms.indexOf('TDS_TH_TA') > -1) {
        searchTypes.push('thesaurus');
    }
    if (query_accoms.indexOf('TDS_SP_TL') > -1) {
        searchTypes.push('spanish');
    }
    return searchTypes;
}

function doDictionaryLinkClick(event){
    var $link = $(this);
    var the_word = $link.text();

    search_type = getSearchType()[0];
    doNewLookup(the_word, methodCall[search_type]);
    
    event.preventDefault();
}

function doSpanishLinkClick(event) {
    var $link = $(this);
    var the_word = $link.text();
    doNewLookup(the_word, methodCall['spanish']);

    event.preventDefault();
}

function doEntrySelect(event) {
    var $entry_li = $(this).parent();
    var entry_index = $entry_li.attr('id').replace('entry_select_item_', '');

    $('.mwEntryData').hide();
    $('#mwEntryData_' + entry_index).show();

    $('.dictionary-selected').removeClass('dictionary-selected');
    $entry_li.addClass('dictionary-selected');

    $('#select_repeat').text($entry_li.text());

    event.preventDefault();
}

function doErrorClick(event){
    $('#dictionary-search input').val('');
    updatePanel('');
    $('#tool-dictionary').removeClass('error');
}

function doNewLookupClick(event){
    var $input = $('#dictionary-search input');
    var the_word = $input.val();

    search_type = 'dictionary';
    doNewLookup(the_word);
}

function doNewLookup(the_word, api){
    api = defaultVal(api, 'get_definitions');
    the_word = sanitizeSearchInput(the_word.toLowerCase());
    $('#dictionary-search input').val(the_word);

    var lookup_url = 'Dictionary.axd/' + api + '?the_dict=' + selected_dict + '&the_word=' + the_word + '&the_group=' + group;
    
    $('#tool-dictionary').addClass('loading');

    $.get(lookup_url, function (rdata) {
        $('#entry_select_div').show();
        updatePanel(rdata);
    }, 'html').always(function(){
        $('#tool-dictionary').removeClass('loading');
    }).fail(function (event) {
        if (event.status == 503) {
            $('#requestTarget').text("reaching Merriam Webster");
        } else {
            $('#requestTarget').text("your request");
        }
        $('#tool-dictionary').addClass('error');
    });
}

function doSearchChange(event){
    var $input = $(this);
    var the_word = $input.val();
    search_type = getSearchType()[0];
    doNewLookup(the_word, methodCall[search_type]);
}

function doSpanishClick(event) {
    var $input = $('#dictionary-search input');
    var the_word = $input.val();
    search_type = 'spanish';
    doNewLookup(the_word, 'get_spanish');
}

function doThesaurusClick(event){
    var $input = $('#dictionary-search input');
    var the_word = $input.val();
    search_type = 'thesaurus';
    doNewLookup(the_word,'get_thesaurus');
}

function handleDictionaryWordLinks(){
    if(search_type=='dictionary' &&
        !$('body').hasClass('TDS_DO_LI') &&
        !$('body').hasClass('TDS_DO_ALL')) {

        $('.dict_link').contents().unwrap();
    }
    if (search_type == 'spanish' &&
        !$('body').hasClass('TDS_SO_LI') &&
        !$('body').hasClass('TDS_SO_ALL')) {

        $('.span_link').contents().unwrap();
    }
}

function handleExactMatches() {
    var dict_exact = $('body').hasClass('TDS_DO_EM');

    if(dict_exact && search_type == 'dictionary') {
        var input = $('#dictionary-search-box').val();
        var reg = new RegExp('^' + input + '($|[^\\s\\w\\-].*$)');
        var entry_count = 0;

        $('li.dictionary a').each(function (index) {
            var $a = $(this);
            var ent = $a.text();

            if(ent.match(reg)) {
                entry_count++;
            }
            else {
                $a.parent().remove();
            }
        });

        $('#found_count').text(entry_count);
    }
}

function linkifyWords(selector) {
    if (!$('body').hasClass("TDS_TO_LI")
        && !$('body').hasClass('TDS_TO_ALL'))
    {
        return;
    }

    var $raw = $(selector);

    $raw.each(function (index) {
        var $span = $(this);
        var span_string = $span.text();

        //a word that isn't in parenthesis or brackets
        var reg = /(?:^|\s)([a-zA-Z][a-zA-Z\-\s]*[a-zA-Z])(?=[\,\;]|$|\s[\(\[])/g;
        var matches = span_string.match(reg);

        //we must replace shorter words first so they don't overwrite a longer word with the same spelling
        matches.sort(function (a, b) {
            return b.length - a.length; // ASC -> a - b; DESC -> b - a
        });

        var result_html = span_string;

        $.each(matches, function (index, match) {
            var new_html = ' <a class="dict_link" href="/">' + match.trim() + '</a>';
            result_html=result_html.replace(match, new_html);
        });

        $span.html(result_html);
    });
}

function linkifySpanishWords(selector) {

    var $raw = $(selector);

    // add class to the links to make them clickable
    $raw.each(function () {
        var $links = $(this).children('a');

        if ($links.length > 0) {
            $links.each(function() {
                $(this).addClass('span_link');
            });
        }
    });
}

function sanitizeSearchInput(input){
    var result = input;
    
    //a string matching this pattern causes the mw api to throw an error.
    if (result.match(/^([pPxX]|[sS]{1,4})[0-9].*$/)){ 
        result = '';
    }

    result = result.trim();

    return result;
}

// this is ran everytime we get new results
function updatePanel(result_html) {

    //display first entry and hide rest
    var $entry_div = $('#mwEntryData');
    $entry_div.hide();
    $('.mwEntryData').remove();
    $entry_div.html(result_html);
    
    //determine the entries once the html is added
    var $entries = $('.mwEntryData');
    $entries.not(':first').hide();
    $entry_div.show();

    //set entry select list
    $('#found_count').text($entries.length);
    $('.results-list ol').html('');
    $('#select_repeat').text($entries.first().find('.entry_label').text());
    var list_html = '';
    $entries.each(function (index) {
        var $entry = $(this);
        list_html += '<li class="dictionary" id="entry_select_item_' + index + '"><a href="#">';
        list_html += $entry.find('.entry_label').text();
        list_html += '</a></li>';

        $entry.attr('id', 'mwEntryData_' + index);
    });
    $('.results-list ol').html(list_html);
    
    //handle thesaurus linkify words
    if ($('.synos-raw').size() > 0 && selected_dict != 'TDS_Dict0'){
        linkifyWords('.synos-raw');
    }

    //taking care of spanish linkify words, about class name
    if (getSearchType().indexOf('spanish') > -1) {
        linkifySpanishWords('.sense-content');
    }

    handleDictionaryWordLinks();    // with those class name, this line will decide to wrap or unwrap the linkify words
    handleExactMatches();

    //handle definition labels
    $('.sn').each(function(index){
        var $sn = $(this);
        var sn_text = $sn.text();
        var sense_class = '';
        
        if (sn_text.match(/^[a-z]$/)){ //match "a"
            sense_class = 'subsense';
        }
        else if (sn_text.match(/^[0-9]+$/)){ // match "1"
            sense_class = 'topsense';
        }
        else{ // match "1 a"
            sense_class = 'mixsense';
        }
        
        $sn.parent().addClass(sense_class);
    });

    //update search type display text
    $('#tool-dictionary').removeClass('dictionary').removeClass('thesaurus');
    if($('li.dictionary').size() > 0){
        $('#tool-dictionary').addClass(search_type);
    }
    

    //html ready to show
    $('#entry_select_div, #selected_entry_div').show();
}

$(document).ready(function () {
    $('#dictionary_btn').click(doNewLookupClick);
    $('#thesaurus_btn').click(doThesaurusClick);
    $('#spanish_btn').click(doSpanishClick);
    $('.results-list ol').on('click', 'a', doEntrySelect);
    $('body').on('click', 'a.dict_link', doDictionaryLinkClick);
    $('body').on('click', 'a.span_link', doSpanishLinkClick);
    $('#dictionary-search-box').enterKey(doSearchChange);
    
    //prevent post on enter press
    $('#dictionary-search-form').submit( function (event) {
        event.preventDefault();
    });

    $('#dictionary-error a').click(doErrorClick);

    //set timeout
    $.ajaxSetup({
        timeout: 15 * 1000
    });
    
    // show the dictionary button when any type of Dictionary enabled
    if (selected_dict != '' && selected_dict != 'TDS_Dict0') {
        $('#dictionary_btn').show();
    }
    
    //prevent dragging
    window.ondragstart = function() {
        return false;
    };
});
