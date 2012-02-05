#Global Coffee Here ...

contact_form = ->
  $('.submit').hide()
  $('#msg').show()
  
$(document.documentElement).delegate('.contact_form .submit', 'click', contact_form)