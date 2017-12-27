// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require bootstrap
//= require jquery_ujs
//= require turbolinks
//= require clipboard
//= require_tree .

$(document).ready(function(){  
  var clipboard = new Clipboard('.copy-text');
  console.log(clipboard);

  $('#filter_out').on('keyup',function(){
    var searchTerm = $(this).val().toLowerCase();
    $('#reminders tr').each(function(){
        var lineStr = $(this).text().toLowerCase();
        if(lineStr.indexOf(searchTerm) !== -1 && searchTerm.length > 0){
          $(this).hide();
        }else{
          $(this).show();
        }
    });
  });
});

