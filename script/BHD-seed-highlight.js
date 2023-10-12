// ==UserScript==
// @name         BHD seed highlighter
// @namespace    http://tampermonkey.net/
// @version      1.3
// @description  try to take over the world!
// @author       Le0pard
// @match        https://beyond-hd.me/torrents*
// @match        https://beyond-hd.me/library*
// @match        https://beyond-hd.me/lists*
// @run-at       document-end
// @grant        none
// ==/UserScript==

(function() {
    'use strict'
    /* globals jQuery, waitForKeyElements */

    jQuery("i.fa-seedling").each(function() {
        jQuery(this).closest("tr").each(function () {
            jQuery(this).find("td").each(function () {
                jQuery(this).attr('style', "background-color: #243916 !important;")
            })
        })
})

})()