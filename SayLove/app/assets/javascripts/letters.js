//= require jquery
//= require jquery_ujs
//= require bootstrap-affix
//= require bootstrap-tab

$(document).ready(function(){
  $('.letter').hover(function () {
    if ($('#single').length <= 0)
      $(this).find('a.view').show();
  }, function () {
    $(this).find('a.view').hide();
  });

  // tab select in single page
  $('#commentsTab a').click(function(e){
    e.preventDefault();
    $(this).tab('show');
  });

  // show flowers tab when has a #flowers hash
  if (window.location.hash == '#flowers') {
    $('#commentsTab a:first').tab('show');
  }

  // favorite
  $('.favorited').hover(function () {
    $(this).children('span').text('取消收藏');
  }, function () {
    $(this).children('span').text('已收藏');
  });

  $('.js-favorite').click(function (e) {
    e.preventDefault();
    var that = this;

    var letter_id = $(this).parents('.letter').attr('data-letter-id');

    $.getJSON('/letters/' + letter_id + '/favorite.json', function (data) {
      if (data.status == 0) {
        if ($(that).hasClass('favorited')) {
          $(that).unbind('hover');

          $(that).removeClass('favorited');
          $(that).children('span').text('收藏');
        } else {
          $(that).addClass('favorited');
          $(that).children('span').text('已收藏');

          $(that).hover(function () {
            $(this).children('span').text('取消收藏');
          }, function () {
            $(this).children('span').text('已收藏');
          });
        }
      } else if (data.status == -2) {
        location.href = '/login?url=/letters/' + letter_id;
      }
    });
  });

  // send flower
  $('.js-flower').click(function (e) {
    e.preventDefault();
    var that = this;
    if ($(that).hasClass('active')) return;

    var letter_id = $(this).parents('.letter').attr('data-letter-id');

    $.getJSON('/letters/' + letter_id + '/flower.json', function (data) {
      if (data.status == 0) {
        $(that).addClass('active');
        $(that).children('span').text('已祝福 ' + data.count);

        $(that).unbind('click');
        $(that).click(function () {
          e.preventDefault();
        });
      } else if (data.status == -2) {
        location.href = '/login?url=/letters/' + letter_id;
      }
    });
  });

  // share button
  $('a.share').click(function (e) {
    e.preventDefault();
  });

  $('a.share').hover(function () {
    if ($(this).next().css('display') == 'none') {
      $(this).next().show();
    }
  }, function (e) {
    if (!$(e.relatedTarget).hasClass('sharebox') && $(e.relatedTarget).parents('.sharebox').length <= 0) {
      $(this).next().hide();
    }
  });

  $('.sharebox').mouseleave(function () {
    $(this).hide();
  });

  // comments
  $('.comment-input textarea').keyup(function () {
    if ($.trim($(this).val()) === '') {
      $(this).parent().find('input').prop('disabled', true);
    } else {
      $(this).parent().find('input').prop('disabled', false);
    }
  });
});
