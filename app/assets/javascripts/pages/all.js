$(document).on('turbolinks:load', function(){
  $('.ui.accordion')
    .accordion()
  ;
  // create sidebar and attach to menu open
  $('.ui.sidebar')
    .sidebar('attach events', '.toc.item');
});