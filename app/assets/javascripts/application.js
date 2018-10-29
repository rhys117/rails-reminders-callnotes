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
//= require_tree .

$(document).ready(function(){
    const clipboard = new Clipboard('.copy-text');

    $('#filter_out').on('keyup', search_and_filter);
    $('#search').on('keyup', search_and_filter);

    if (document.getElementById("search") !== null) {
        search_and_filter();
    }

    const enquiry_notes= $("#call_note_enquiry_notes");
    const work_notes = $("#call_note_work_notes");
    textareaResize(enquiry_notes, work_notes);
    textareaResize(work_notes, enquiry_notes);

    if (window.location.pathname === '/call_notes/new') {
        disable_enter_key();
    }
});

function disable_enter_key() {
    jQuery(function($) {
        $(document).on("keydown", function(e) {
            if (e.which === 13 && !$(e.target).is("textarea")) {
                e.preventDefault();
                console.log("ENTER PREVENTED");
            }
        });
    });
}

// search and filter on reminder pages
function search_and_filter(){
    let searchTerm = $('#search').val().toLowerCase();
    let filterTerm = $('#filter_out').val().toLowerCase();

    $('#reminders tbody tr').each(function(){
        let lineStr = $(this).text().toLowerCase();
        if(lineStr.indexOf(searchTerm.trim()) === -1 && searchTerm.length > 0){
            $(this).hide();
        } else if(lineStr.indexOf(filterTerm.trim()) !== -1 && filterTerm.length > 0) {
            $(this).hide();
        } else {
            $(this).show();
        }
    });
}

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
  if ($('#btn-'+ type + '-form').text() === 'hide') {
    $('#btn-'+ type + '-form').text('show');
    $('#' + type + "-form").attr('class', 'hidden');
  } else {
    $('#btn-'+ type + '-form').text('hide');
    $('#' + type + "-form").attr('class', '');
  }
}

// show/hide work notes
function ToggleWorkNotes() {
  if ($('#btn-hide-work').text() === 'hide') {
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

// This function is still not working properly
function textAreaLinesChange(object, lines, question, answer, i) {
    let old_value = object.oldvalue.trim();
    // if value already set for textarea
    if (old_value.length >= 1) {
        debugger;
        let notes_past_question = lines.slice(0, i).reverse().join('\n');
        // if can find old value find and set changed notes
        if (notes_past_question.includes(old_value)) {
            let altered = notes_past_question.replace(old_value, '\n' + answer + '\n');
            let changed_notes = lines.slice(i).reverse().join('\n') + altered;
            lines = changed_notes.split('\n').reverse();
            // if can't match old value
        } else {
            lines[i] = question + '\n' + answer ;
        }
    } else {
        lines[i] = question + '\n' + answer;
    }
    return lines;
}

function ReplaceNextLine(object, lines, question, input_type, answer) {
    for(let i = 0; i < lines.length; i++) {
        let current_line = lines[i].split(':')[0].trim() + ':';
        if (current_line === question) {
            // if textarea
            if (input_type === 'textarea') {
                lines = textAreaLinesChange(object, lines, question, answer, i)
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
    let question = $(this).attr('data-question').trim() + ':';
    let heading_line = $(this).attr('data-heading').trim();
    let answer = $(this).val();
    let input_type = $(this)[0].type;
    let type = $(this).attr('id').split('_')[0];
    let id = "#call_note_" + type + '_notes';

    let notes = $(id).val();

    // reverse so we search for the last instance of the question
    let reversed_lines = notes.split("\n").reverse();
    let before = [];
    let after = [];

    for(let i = 0; i < reversed_lines.length; i++) {
        current_line = reversed_lines[i].split(':')[0].trim();
        // find question heading if exists
        if (current_line === heading_line) {
            let reversed_index = i;
            let unreversed = reversed_lines.reverse();

            let normal_index = unreversed.length - reversed_index - 1;
            before = unreversed.slice(0, normal_index);
            let after_heading = unreversed.slice(normal_index);
            let next_line_break = after_heading.findIndex(line => line.length === 0);
            // possibility no more line breaks
            if (next_line_break === -1) {
                next_line_break = after_heading.length
            }

            reversed_lines = after_heading.slice(0, next_line_break);
            after = unreversed.slice(normal_index + next_line_break);

            before.reverse();
            reversed_lines.reverse();
            after.reverse();
        }
    }
    if (input_type === 'textarea') {
        let lines_and_after = reversed_lines.reverse().concat(after).reverse();
        reversed_lines = ReplaceNextLine(this, lines_and_after, question, input_type, answer);
        let lines = before.reverse().concat(reversed_lines.reverse());
        var changed_notes = lines.join('\n');
    } else {
        reversed_lines = ReplaceNextLine(this, reversed_lines, question, input_type, answer);

        let lines = before.reverse().concat(reversed_lines.reverse(), after.reverse());
        var changed_notes = lines.join('\n');
    }
    $(id).val(changed_notes.trim())
  });
});

function escapeRegExp(text) {
  return text.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, '\\$&');
}

function DeleteLine(line, type) {
  // Deletes line and also blank line afterwards if one
  // searching in reverse so it's always last instance in notes
    $("[data-question='" + line + "']").remove();
    let regex = new RegExp("(?=" + escapeRegExp(line ) + ":).*\n?", 'm');
    let id = '#call_note_' + type + '_notes';
    let notes = $(id).val();
    let lines = notes.split("\n").reverse();

    let index_of_line = lines.findIndex(value => regex.test(value));

    if (index_of_line === -1) {
        return;
    }

    let next_line_blank_space = lines[index_of_line - 1] === "\n";

    // remove deleted line and also next line if white space
    if (next_line_blank_space === true) {
      lines.splice(index_of_line - 1, 2);
    } else {
        lines.splice(index_of_line, 1);
    }

    let removed_line_notes = lines.reverse().join('\n');
    $(id).val(removed_line_notes);
}

function PrependToCorrespondenceNotes(string) {
  let content = $("#"+string).val();
  let current_notes = $('#call_note_correspondence_notes').val();
  let combined = (current_notes + "\n" + content).trim() + "\n";
  $('#call_note_correspondence_notes').val(combined);
}

function PrependToNotes(selection, type) {
    let content = $("#" + type + '_' + selection).val().replace(/(?={)[^}]*./, '').replace(/^Note -.*$/m,"").trim();
    let current_notes = $('#call_note_' + type + '_notes').val();
    // remove trailing line breaks except one
    if (current_notes.length > 1) {
      current_notes = current_notes.trim() + "\n\n";
    }
    let combined = current_notes + content + "\n";
    let filtered = combined.replace(/textarea|pingtest|speedtests/g, "");
    $('#call_note_' + type + '_notes').val(filtered);
    $('#' + type + '-template-header').attr('class', '')
}

// Presets for reminder create
function PresetOnlineUsage(){
  $('#reminder_check_for').val('online/usage');
  $('#reminder_priority').val('2');
  $('#reminder_select_date').val('2');
}

function PresetCustomerContact(){
  $('#reminder_check_for').val('customer contact');
  $('#reminder_priority').val('2');
  $('#reminder_select_date').val('5');
}

function PresetNbnResponse(){
  $('#reminder_check_for').val('nbn response');
  $('#reminder_priority').val('3');
  $('#reminder_select_date').val('2');
}

function PresetWorkTicketUpdate(){
  $('#reminder_check_for').val('work ticket update');
  $('#reminder_priority').val('2');
  $('#reminder_select_date').val('2');
}

function PresetVocusResponse(){
  $('#reminder_check_for').val('vocus response');
  $('#reminder_priority').val('3');
  $('#reminder_select_date').val('2');
}

function Preset2DayWarning(){
  $('#reminder_check_for').val('2DayWarning');
  $('#reminder_priority').val('1');
  $('#reminder_select_date').val('2');
}

function PresetResolved(){
  $('#reminder_check_for').val('resolved');
  $('#reminder_priority').val('1');
  $('#reminder_select_date').val('2');
}