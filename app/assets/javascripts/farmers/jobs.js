$(document).on('turbolinks:load', function(){
  $('.jobs.new, .jobs.create, .jobs.edit, .jobs.update').ready(function(){
    $('.ui.dropdown').dropdown();
    $('.range-start').calendar({
      type: 'date',
      startMode: 'month',
      endCalendar: $('.range-end'),
      initialDate: new Date()
    });

    $('.range-end').calendar({
      type: 'date',
      startMode: 'month',
      startCalendar: $('.range-start'),
      initialDate: new Date()
    });
  });
});