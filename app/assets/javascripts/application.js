// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui-1.10.3.custom.min
//= require autocomplete-rails
//= require_tree .
function ChangeValue(th) {
    $(th).find('input:radio')[0].checked = true;
    $("#user_city").val($(th).find('input:radio').val());
}

$(document).ready(function() {
    $('input:radio').each(function() {
        $(this).parent("li").removeClass("active");
        if ($(this).is(':checked') === true) {
            $(this).parent("li").addClass("active");
            $("#user_city").val($(this).val());
        }
    });
});