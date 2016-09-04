$(document).on('turbolinks:load', function(){
  $('#mobile-nav').on('click',function(){
    $('.mobile .ui.vertical.menu').toggle();
  });
});