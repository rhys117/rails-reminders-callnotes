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

    $('#filter_out').on('keyup', search_and_filter);
    $('#search').on('keyup', search_and_filter);

    $('#filter_out').val(localStorage.getItem("filter_out"));
    $('#search').val(localStorage.getItem("search"));

    if (document.getElementById("search") !== null) {
      search_and_filter();
    }

    textareaResize($("#call_note_enquiry_notes"), $("#call_note_work_notes"));
    textareaResize($("#call_note_work_notes"), $("#call_note_enquiry_notes"));

    // stop enter key from submitting form on notes page but allow in textareas
    if (window.location.pathname == '/call_notes/new') {
      jQuery(function($) {
        $(document).on("keydown", function(e) {
          if (e.which === 13 && !$(e.target).is("textarea")) {
            e.preventDefault();
            console.log("ENTER PREVENTED");
            return;
          }
        });
      });
    }
  });

  function search_and_filter(){
    var searchTerm = $('#search').val().toLowerCase();
    var filterTerm = $('#filter_out').val().toLowerCase();

    localStorage.setItem("search", searchTerm);
    localStorage.setItem("filter_out", filterTerm);

    $('#reminders tbody tr').each(function(){
      var lineStr = $(this).text().toLowerCase();
      if(lineStr.indexOf(searchTerm.trim()) === -1 && searchTerm.length > 0){
        $(this).hide();
      } else if(lineStr.indexOf(filterTerm.trim()) !== -1 && filterTerm.length > 0) {
        $(this).hide();
      } else {
        $(this).show();
      }
    });
  }
})

// This fiddle shows how to simulate a resize event on a
// textarea
// Tested with Firefox 16-25 Linux / Windows
// Chrome 24-30 Linux / Windows

var textareaResize = function(source, dest) {
  var resizeInt = null;

  // the handler function
  var resizeEvent = function() {
    dest.outerHeight(source.outerHeight());
  };

  // This provides a "real-time" (actually 15 fps)
  // event, while resizing.
  // Unfortunately, mousedown is not fired on Chrome when
  // clicking on the resize area, so the real-time effect
  // does not work under Chrome.
  source.on("mousedown", function(e) {
    resizeInt = setInterval(resizeEvent, 1000/15);
  });

  // The mouseup event stops the interval,
  // then call the resize event one last time.
  // We listen for the whole window because in some cases,
  // the mouse pointer may be on the outside of the textarea.
  $(window).on("mouseup", function(e) {
    if (resizeInt !== null) {
      clearInterval(resizeInt);
    }
    resizeEvent();
  });
};

function ToggleForm(type) {
  if ($('#btn-'+ type + '-form').text() == 'hide') {
    $('#btn-'+ type + '-form').text('show');
    $('#' + type + "-form").attr('class', 'hidden');
  } else {
    $('#btn-'+ type + '-form').text('hide');
    $('#' + type + "-form").attr('class', '');
  }
}

function ToggleWorkNotes() {
  if ($('#btn-hide-work').text() == 'hide') {
    $("#call_note_work_notes").attr('class', 'hidden');
    $(".enquiry-section").attr('class', 'enquiry-section form-group col-md-10');
    $(".work-section").attr('class', 'work-section form-group col-md-2');
    $("#call_note_additional_notes").css('width', '100%');
    $("#call_note_additional_notes").css('width', '100%');
    $('#btn-hide-work').text('show');
  }
  else {
    $("#call_note_work_notes").attr('class', 'form-control');
    $(".enquiry-section").attr('class', 'enquiry-section form-group col-md-6');
    $(".work-section").attr('class', 'work-section form-group col-md-6');
    $('#btn-hide-work').text('hide');
  }
}

$(function() {
  $(document).on('change', '.question', function() {
    var question = $(this).attr('data-question').trim() + ':';
    var answer = $(this).val();
    var input_type = $(this)[0].type;
    var id = $(this).attr('id').split('_')[0];

    if (id == 'enquiry') {
      id = 'enquiry'
    }

    var notes = $("#call_note_" + id + '_notes').val();
    var lines = notes.split("\n").reverse();

    for(var i = 0;i < lines.length;i++){
      notes_line_question = lines[i].split(':')[0].trim() + ':';
      if (notes_line_question == question) {
        if (input_type == 'textarea') {
          var old_value = this.oldvalue;
          if (old_value.length > 1) {
            var notes_past_question = lines.slice(0,i).reverse().join('\n');
            if (notes_past_question.includes(old_value)) {
              var altered = notes_past_question.replace(old_value, answer);
              var changed_notes = lines.slice(i, lines.length).reverse().join('\n') + '\n' + altered.trim();
              $("#call_note_" + id + '_notes').val(changed_notes.trim());
              return
            } else {
              lines[i] = question + " \n" + answer + "\n";
            }
          } else {
            lines[i] = question + " \n" + answer + "\n";
          }
        } else {
          lines[i] = question + ' ' + answer;
        }
        break
      }
    }

    var changed_notes = lines.reverse().join('\n');
    $("#call_note_" + id + '_notes').val(changed_notes)
  });
});


function PrependToEnquiryNotes(string) {
  var content = $("#"+string).val();
  var current_notes = $('#call_note_enquiry_notes').val().trim();
  var combined = (current_notes + "\n\n" + content).trim() + "\n\n";
  var filtered = combined.replace(/textarea|pingtest|speedtests/g, "");
  $('#call_note_enquiry_notes').val(filtered);
  $('#enquiry-template-header').attr('class', '')
}

function PrependToCorrespondenceNotes(string) {
  var content = $("#"+string).val();
  var current_notes = $('#call_note_correspondence_notes').val();
  var combined = (current_notes + "\n" + content).trim() + "\n";
  $('#call_note_correspondence_notes').val(combined);
}

function PrependToWorkNotes(string) {
  var content = $("#"+string).val();
  var current_notes = $('#call_note_work_notes').val();
  var combined = current_notes + content + "\n";
  var filtered = combined.replace(/textarea|pingtest|speedtests/g, "");
  $('#call_note_work_notes').val(filtered);
  $('#work-template-header').attr('class', '')
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