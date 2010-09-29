function current_tz_tr() {
  return $('#' + tz_code().replace('+', 'p'));
}

function display_original_timezone() {
  $('.original').
    show().
    find('td.identifier').
    html('Original:');
}

function display_user_timezone() {
  current_tz_tr().
    show().
    addClass('user').
    find('td.identifier').
    html('Your time:');
}

function display_major_timezones() {
  $('.major').show();
}

$(document).ready(function() {
    display_original_timezone();
    display_user_timezone();
    display_major_timezones();
});

function show_all() {
  current_tz_tr().siblings().show();
  $('.all_timezones').hide();
}
