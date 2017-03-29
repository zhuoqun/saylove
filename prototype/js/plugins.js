window.log = function f(){ log.history = log.history || []; log.history.push(arguments); if(this.console) { var args = arguments, newarr; args.callee = args.callee.caller; newarr = [].slice.call(args); if (typeof console.log === 'object') log.apply.call(console.log, console, newarr); else console.log.apply(console, newarr);}};
(function(a){function b(){}for(var c="assert,count,debug,dir,dirxml,error,exception,group,groupCollapsed,groupEnd,info,log,markTimeline,profile,profileEnd,time,timeEnd,trace,warn".split(","),d;!!(d=c.pop());){a[d]=a[d]||b;}})
(function(){try{console.log();return window.console;}catch(a){return (window.console={});}}());

$(document).ready(function(){
  $('#account_type').change(function(){
    switch($(this).val()){
      case 'weibo':
        $('.username label').text('Ta 的新浪微博账号');
        $('.username a').text('如何找到对方的新浪微博账号？');
        break;
      case 'douban':
        $('.username label').text('Ta 的豆瓣 ID');
        $('.username a').text('如何找到对方的豆瓣 ID？');
        break;
      case 'renren':
        $('.username label').text('Ta 的人人 ID');
        $('.username a').text('如何找到对方的人人 ID？');
        break;
    }
  });
});
