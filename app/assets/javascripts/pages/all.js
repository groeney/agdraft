$(document).on('turbolinks:load', function(){
  $('.ui.accordion').accordion();
  $('.ui.dropdown.item').dropdown({
    on: 'hover'
  });
  // create sidebar and attach to menu open
  $('.ui.sidebar').sidebar('attach events', '.toc.item');
});