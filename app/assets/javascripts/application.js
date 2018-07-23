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

  // search and filter on reminder pages
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

// resize work notes to match enquiry notes size at all times
var textareaResize = function(source, dest) {
  var resizeInt = null;

  var resizeEvent = function() {
    dest.outerHeight(source.outerHeight());
  };

  source.on("mousedown", function(e) {
    resizeInt = setInterval(resizeEvent, 1000/15);
  });

  $(window).on("mouseup", function(e) {
    if (resizeInt !== null) {
      clearInterval(resizeInt);
    }
    resizeEvent();
  });
};

// show/hide enquiry or work form for call notes
function ToggleForm(type) {
  if ($('#btn-'+ type + '-form').text() == 'hide') {
    $('#btn-'+ type + '-form').text('show');
    $('#' + type + "-form").attr('class', 'hidden');
  } else {
    $('#btn-'+ type + '-form').text('hide');
    $('#' + type + "-form").attr('class', '');
  }
}

// show/hide work notes
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

function ReplaceNextLine(object, lines, question, input_type, answer) {
    for(var i = 0; i < lines.length; i++) {
        current_line = lines[i].split(':')[0].trim() + ':';
        if (current_line === question) {
            // if textarea
            if (input_type === 'textarea') {
                var old_value = object.oldvalue.trim();
                // if value already set for textarea
                if (old_value.length > 1) {
                    var notes_past_question = lines.slice(0, i).reverse().join('\n');
                    // if can find old value find and set changed notes
                    if (notes_past_question.includes(old_value)) {
                        var altered = notes_past_question.replace(old_value, answer);
                        var changed_notes = lines.slice(i).reverse().join('\n') + '\n'.trim() + altered.trim();
                        return changed_notes.split('\n').reverse();
                        // if can't match old value
                    } else {
                        lines[i] = question + '\n' + answer + '\n';
                    }
                } else {
                    lines[i] = question + '\n' + answer + '\n';
                }
                // if not textarea
            } else {
                lines[i] = question + ' ' + answer;
            }
            // break so it only changes one line
            break
        }
    }
    return lines
}

// Dynamically change textarea based on selection of question
$(function() {
  $(document).on('change', '.question', function() {
    var question = $(this).attr('data-question').trim() + ':';
    var heading_line = $(this).attr('data-heading').trim();
    var answer = $(this).val();
    var input_type = $(this)[0].type;
    var type = $(this).attr('id').split('_')[0];
    var id = "#call_note_" + type + '_notes';


    var notes = $(id).val();

    // reverse so we search for the last instance of the question
    var lines = notes.split("\n").reverse();
    var before = [];
    var after = [];

    for(var i = 0; i < lines.length; i++) {
        current_line = lines[i].split(':')[0].trim();
        // find question heading if exists
        if (current_line === heading_line) {
            var reversed_index = i;
            var unreversed = lines.reverse();

            var normal_index = unreversed.length - reversed_index - 1;
            before = unreversed.slice(0, normal_index);
            var after_heading = unreversed.slice(normal_index);
            var next_line_break = after_heading.findIndex(line => line.length === 0);
            // possibility no more line breaks
            if (next_line_break === -1) {
                next_line_break = after_heading.length
            }

            lines = after_heading.slice(0, next_line_break);
            after = unreversed.slice(normal_index + next_line_break);

            before.reverse();
            lines.reverse();
            after.reverse();
        }
    }
    lines = ReplaceNextLine(this, lines, question, input_type, answer);
    lines = before.reverse().concat(lines.reverse(), after.reverse())

    var changed_notes = lines.join('\n');
    $(id).val(changed_notes.trim())
  });
});

function escapeRegExp(text) {
  return text.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, '\\$&');
}

function DeleteLine(line, type) {
  // Deletes line and also blank line afterwards if one
  // searching in reverse so it's always last instance in notes
    var regex = new RegExp("(?=" + escapeRegExp(line ) + ").*\n?", 'm');
    var id = '#call_note_' + type + '_notes';
    var notes = $(id).val();
    var lines = notes.split("\n").reverse();

    var index_of_line = lines.findIndex(value => regex.test(value));

    if (index_of_line === -1) {
        return;
    }

    var next_line_blank_space = lines[index_of_line - 1] === "\n";

    // remove deleted line and also next line if white space
    if (next_line_blank_space === true) {
      lines.splice(index_of_line - 1, 2);
    } else {
        lines.splice(index_of_line, 1);
    }

    var removed_line_notes = lines.reverse().join('\n');
    $(line).val(removed_line_notes);
}

function PrependToCorrespondenceNotes(string) {
  var content = $("#"+string).val();
  var current_notes = $('#call_note_correspondence_notes').val();
  var combined = (current_notes + "\n" + content).trim() + "\n";
  $('#call_note_correspondence_notes').val(combined);
}

function PrependToNotes(selection, type) {
    var content = $("#" + type + '_' + selection).val().replace(/(?={)[^}]*./, '').replace(/^Note -.*$/m,"").trim();
    var current_notes = $('#call_note_' + type + '_notes').val();
    // remove trailing line breaks except one
    if (current_notes.length > 1) {
      current_notes = current_notes.trim() + "\n\n";
    }
    var combined = current_notes + content + "\n";
    var filtered = combined.replace(/textarea|pingtest|speedtests/g, "");
    $('#call_note_' + type + '_notes').val(filtered);
    $('#' + type + '-template-header').attr('class', '')
}

// Presets for reminder create
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