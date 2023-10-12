// ==UserScript==
// @name         Gazelle Quick Download
// @namespace    http://tampermonkey.net/
// @version      1.0.1
// @description  Copy a page worth of (non-sticky) Gazelle download links to your clipboard for easy pasting
// @author       KingKrab23
// @match        https://*/torrents.php*
// @grant        none
// @require      https://code.jquery.com/jquery-1.7.2.min.js
// ==/UserScript==

$(".linkbox").first().before('<button id="copy_dl_links_to_clipboard" style="margin-top:15px;margin-left:15px;">Copy DL links to clipboard</button>');

var $temp = $("<textarea class='hidden'>");
$("body").append($temp);

$("#copy_dl_links_to_clipboard").click(function () {
    $temp.toggleClass("hidden");

    $(".group_torrent.hidden").remove();
    copy_dl_links_to_clipboard();

    //$temp.toggleClass("hidden");
});

function copy_dl_links_to_clipboard() {
    var icon = false;
    //--- Note that contains() is CASE SENSITIVE.
    var specLink = $("a:contains('DL')"); // GGn

    if (!specLink.length || specLink.length === 0) {
        icon = true;
        specLink = $(".icon_disk_none");
    }

    if (specLink.length) {
        var text_to_copy = "";
        if (icon === true) {
            $.each( specLink, function( key, value ) {
                var path = $(this).parent().attr('href');

                var getUrl = window.location;
                var baseUrl = getUrl.protocol + "//" + getUrl.host + "/";

                text_to_copy += baseUrl + path + "\n";
            });
        } else {
            $.each( specLink, function( key, value ) {
                text_to_copy += value + "\n";
            });
        }

        copyToClipboard(text_to_copy);
        alert(specLink.length + ' torrents have been added to your clipboard');
    }
}

function copyToClipboard(textToCopy) {
    $temp.val(textToCopy).select();
    document.execCommand("copy");
    $temp.val('');
}
