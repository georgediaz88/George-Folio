$(document).ready(function() {
    $('.contact_form .submit').bind('click', contact_form);
});

function contact_form() {
  $('.submit').hide();
  $('#msg').show();
};