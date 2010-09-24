function submitForm() {
  root_url = location.protocol + '//' + location.host;
  window.location = root_url + '/' + $('input').val();
  return false;
}

$(function() {
  $('form').submit(submitForm);
  $('input').focus();
})

