function current_tz_tr() {
  return $('#' + tz_code().replace('+', 'p'));
}

$(document).ready(function() {
  current_tz_tr().
  addClass('user').
  show().
  find('td.identifier').
  html('Your time:');
});

function show_all() {
  current_tz_tr().siblings().show();
}
