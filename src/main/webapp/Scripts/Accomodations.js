var do_accomodations = [
    "TDS_DO_SL", //SoundLinks Enabled
    "TDS_DO_WO", //Word Origin Enabled
    "TDS_DO_TA", //Thesaurus Enabled
    "TDS_DO_LI", //Linkify words
    "TDS_DO_EM", //Exact matches only : NOT YET IMPLEMENTED
    "TDS_DO_PR", //Pronunciations
    "TDS_DO_VI", //Verbal Illustrations
    "TDS_DO_SSL", //Subject status label
    "TDS_DO_LB" //Label for usage
    //"TDS_DO_None" //No extra options
];//"TDS_DO_ALL",      //All options

var to_accomodations=[
    //"TDS_TH0",         //No thesaurus
    "TDS_TH_TA",       //Enable thesaurus
    "thesaurus",
    //"TDS_TO_None",     //No thesaurus extras
    "TDS_TO_ALL",      //All thesaurus options
    "TDS_TO_LI"       //Linkify thesaurus results
];

var so_accomodations = [
    "TDS_SP_TL", //Enable spanish
    "TDS_SO_LI", //Linkify spanish words
    "TDS_SO_ALL" //All spanish options
];

function addAccomClasses(class_arr){
    var classes = class_arr.join(' ');
    var $dest = $('body');
    $dest.addClass(classes);
}

function processAccomBlock(code_all, accom_arr, query_string){
    var results_arr = [];

    if(query_string.indexOf(code_all) != -1) {
        results_arr=results_arr.concat(accom_arr);
    }
    else {
        $.each(accom_arr, function (index, val) {
            if(query_string.indexOf(val) != -1) {
                results_arr.push(val);
            }
        });
    }

    return results_arr;
}

function processQueryStringAccoms(query_string){
    var results_arr = [];

    var do_accom = processAccomBlock('TDS_DO_ALL', do_accomodations, query_string);
    results_arr=results_arr.concat(do_accom);

    var to_accom = processAccomBlock('TDS_TO_ALL', to_accomodations, query_string);
    results_arr = results_arr.concat(to_accom);

    var so_accom = processAccomBlock('TDS_SO_ALL', so_accomodations, query_string);
    results_arr = results_arr.concat(so_accom);
    
    addAccomClasses(results_arr);
}

$(document).ready(function(){
    processQueryStringAccoms(query_accoms);
});