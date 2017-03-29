//= require jquery
//= require jquery_ujs
//= require jquery.cookie
//= require bootstrap-modal
//= require bootstrap-tab

$(document).ready(function(){

  // help modal tab select 
  $('#helpTab a').click(function(e){
    e.preventDefault();
    $(this).tab('show');
  });

  $('#account_type').change(function(){
    switch($(this).val()){
      case 'weibo':
        $('.username label').text('Ta 的新浪微博账号');
        $('.username a').text('如何找到对方的新浪微博账号？');
        $('.help-weibo').tab('show');
        break;
      case 'douban':
        $('.username label').text('Ta 的豆瓣 ID');
        $('.username a').text('如何找到对方的豆瓣 ID？');
        $('.help-douban').tab('show');
        break;
    }

    getUserId();
  });

  $('#public').change(function () {
    $('#commentson').prop('checked', true);
    $('.comments-setting').toggleClass('hide');
  });

  $('#username').click(function () {
    $(this).select();
  });

  var last_name = '';
  $('#username').keyup(function () {
    var name = $.trim($(this).val());
    var type = $('#account_type').val();

    if (last_name !== type+name) {
      $('#userid').val('');
      last_name = '';
    }


    if (name == '' && $('.username .js-help').css('display') == 'none') {
      $('.username .js-search').hide();
      $('.username .js-help').show();
    }
  });

  // auto save data
  function saveData() {
      var content = $.trim($('#content').val());
      if ( content == '') {
          return;
      } else {
        setDraft(content);
      }
  }

  function setDraft(content) {
    var uid = $('#my_uid').val();

    if (uid) {
      $.cookie(uid, content, {expires: 7, path: '/'});
    }
  }

  setInterval(saveData, 2000);

  // make sure the user input is valid
  var requesting = false;
  $('#username').blur(getUserId);

  function getUserId() {
    // call the api
    var name = $.trim($('#username').val());
    var type = $('#account_type').val();

    if (name == '' || requesting || last_name == type+name) return;

    requesting = true
    last_name = type+name

    resetSearchTipsAndShow();

    $.getJSON('/search/' + type + '/' + encodeURIComponent(name) + '.json', function (data) {
      requesting = false

      if (data.status == 0) {
        $('#userid').val(data.id);

        $('.username .js-search .loading').hide();
        $('.username .js-search .correct').show();
        $('.username .js-search span').text('此用户真实存在');

        activateSubmit();
      } else if (data.status == -1) {
        $('.username .js-search .loading').hide();
        $('.username .js-search .correct').hide();
        $('.username .js-search span').addClass('error');
        $('.username .js-search span').text('此用户不存在');

        $('#username').select();
        $('.publish').prop('disabled', true);
      } else if (data.status == -2) {
        alert('服务器出错了，请稍候再试');
      }
    });
  }

  function resetSearchTipsAndShow() {
    $('#userid').val('');
    $('.publish').prop('disabled', true);

    $('.username .js-help').hide();

    $('.username .js-search .loading').show();
    $('.username .js-search .correct').hide();
    $('.username .js-search span').removeClass('error');
    $('.username .js-search span').text('正在验证用户是否存在..');
    $('.username .js-search').show();
  }

  function activateSubmit() {
    if ($.trim($('#username').val()) !== '' && $.trim($('#content').val()) !== '') {
      $('.publish').prop('disabled', false);
    } else {
      $('.publish').prop('disabled', true);
    }
  }

  $('#content').keyup(activateSubmit);

  var submiting = false;
  // submit the form
  $('.publish').click(function () {
    submiting = true;
    setDraft('');
  });

  // on window exit
  $(window).on('beforeunload', function(e){
    if (!submiting) {
      if ($.trim($('#username').val()) !== '' || $.trim($('#content').val()) !== '') {
        return '离开本页可能会导致所写的内容丢失，你确定要离开吗？';
      }
    }
  });
});
