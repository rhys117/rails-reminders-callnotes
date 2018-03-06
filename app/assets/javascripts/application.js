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
//= require jquery.turbolinks
//= require jquery_ujs
//= require clipboard
//= require bootstrap
//= require turbolinks

//= require_tree .

document.addEventListener("turbolinks:load", function() {
  $(document).ready(function(){
    var clipboard = new Clipboard('.copy-text');
    console.log(clipboard);

    $('#filter_out').on('keyup', search_and_filter);
    $('#search').on('keyup', search_and_filter);

    $('#filter_out').val(localStorage.getItem("filter_out"));
    $('#search').val(localStorage.getItem("search"));

    search_and_filter();

  });

  function search_and_filter(){
    var searchTerm = $('#search').val().toLowerCase();
    var filterTerm = $('#filter_out').val().toLowerCase();

    localStorage.setItem("search", searchTerm);
    localStorage.setItem("filter_out", filterTerm);

    $('#reminders tbody tr').each(function(){
      var lineStr = $(this).text().toLowerCase();
      if(lineStr.indexOf(searchTerm) === -1 && searchTerm.length > 0){
        $(this).hide();
      } else if(lineStr.indexOf(filterTerm) !== -1 && filterTerm.length > 0) {
        $(this).hide();
      } else {
        $(this).show();
      }
    });
  }
})

function PrependToEnquiryNotes(string) {
  var content = $("#"+string).val();
  var current_notes = $('#call_note_additional_notes').val();
  var combined = current_notes + "\n" + content + "\n";
  $('#call_note_additional_notes').val(combined);
}

function PrependToWorkNotes(string) {
  var content = $("#"+string).val();
  var current_notes = $('#call_note_work_notes').val();
  var combined = current_notes + content;
  $('#call_note_work_notes').val(combined);
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