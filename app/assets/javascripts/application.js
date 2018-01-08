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
//= require jquery_ujs
//= require clipboard
//= require bootstrap
//= require turbolinks

//= require_tree .

$(document).ready(function(){
  var clipboard = new Clipboard('.copy-text');
  console.log(clipboard);

  $('#filter_out').on('keyup', filter_out);
  $('#search').on('keyup', search);

  // filter_out_alt(localStorage.getItem("filter_out"));
  // search_alt(localStorage.getItem("search"));

  $('#filter_out').val(localStorage.getItem("filter_out"));
  $('#search').val(localStorage.getItem("search"));

  // this is temp fix
  filter_out_alt(localStorage.getItem("filter_out"));

});

function filter_out(){
  var searchTerm = $(this).val().toLowerCase();
  localStorage.setItem("filter_out", searchTerm);
  console.log('this');
  $('#reminders tbody tr').each(function(){
      var lineStr = $(this).text().toLowerCase();
      if(lineStr.indexOf(searchTerm) !== -1 && searchTerm.length > 0){
        $(this).hide();
      }else{
        $(this).show();
      }
  });
}

function filter_out_alt(filter){
  var searchTerm = filter.toLowerCase();
  localStorage.setItem("filter_out", searchTerm);
  $('#reminders tbody tr').each(function(){
      var lineStr = $(this).text().toLowerCase();
      if(lineStr.indexOf(searchTerm) !== -1 && searchTerm.length > 0){
        $(this).hide();
      }else{
        $(this).show();
      }
  });
}

function search(){
  var searchTerm = $(this).val().toLowerCase();
  localStorage.setItem("search", searchTerm);
  $('#reminders tbody tr').each(function(){
      var lineStr = $(this).text().toLowerCase();
      if(lineStr.indexOf(searchTerm) === -1 && searchTerm.length > 0){
        $(this).hide();
      }else{
        $(this).show();
      }
  });
}

function search_alt(search){
  var searchTerm = search.toLowerCase();
  localStorage.setItem("search", searchTerm);
  $('#reminders tbody tr').each(function(){
      var lineStr = $(this).text().toLowerCase();
      if(lineStr.indexOf(searchTerm) === -1 && searchTerm.length > 0){
        $(this).hide();
      }else{
        $(this).show();
      }
  });
}

function PresetOnlineUsage(){
  $('#reminder_check_for').val('online/usage')
  $('#reminder_priority').val('2')
  $('#reminder_select_date').val('2')
}

function PresetCustomerContact(){
  $('#reminder_check_for').val('customer contact')
  $('#reminder_priority').val('2')
  $('#reminder_select_date').val('5')
}

function PresetNbnResponse(){
  $('#reminder_check_for').val('nbn response')
  $('#reminder_priority').val('3')
  $('#reminder_select_date').val('2')
}

function PresetWorkTicketUpdate(){
  $('#reminder_check_for').val('work ticket update')
  $('#reminder_priority').val('2')
  $('#reminder_select_date').val('2')
}

function PresetVocusResponse(){
  $('#reminder_check_for').val('vocus response')
  $('#reminder_priority').val('3')
  $('#reminder_select_date').val('2')
}

function Preset2DayWarning(){
  $('#reminder_check_for').val('2DayWarning')
  $('#reminder_priority').val('1')
  $('#reminder_select_date').val('2')
}

function PresetResolved(){
  $('#reminder_check_for').val('resolved')
  $('#reminder_priority').val('1')
  $('#reminder_select_date').val('2')
}