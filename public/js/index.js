/**
 * Created with JetBrains PhpStorm.
 * User: andrewmillman
 * Date: 11/9/13
 * Time: 2:01 AM
 * To change this template use File | Settings | File Templates.
 */
$(document).ready(function() {

    var highlight = "rgb(73, 153, 255)";
    $(".container.navigation, #shadow").click(function() {
        $(".collapsable").toggleClass("collapsed");
        $(".container.navigation").css({"background-color":highlight}).animate(
           {"background-color":"#486480"},500);
    });

    $(".row.descrip").click(function() {
        var color = $(this).css("background-color");
        $(this).css({"background-color":highlight}).animate(
            {"background-color":color},500);
    })
});