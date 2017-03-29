//= require jquery
//= require jquery_ujs
//= require bootstrap-affix

$(document).ready(function(){
  // for settings
  $('.js-edit').click(function (e) {
    e.preventDefault();
    $('.my-email .js-display').hide();
    $('.my-email .js-edit').show();
  });
});
