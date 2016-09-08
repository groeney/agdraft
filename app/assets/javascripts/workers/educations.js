$(document).on('turbolinks:load', function(){
  $('.educations.new, .educations.create').ready(function(){
    $('.range-start').calendar({
      type: 'date',
      startMode: 'year',
      endCalendar: $('.range-end'),
      maxDate: new Date(),
      initialDate: new Date(new Date().getFullYear(), 0, 1),
    });

    $('.range-end').calendar({
      type: 'date',
      startMode: 'year',
      startCalendar: $('.range-start'),
      maxDate: new Date(),
      initialDate: new Date(new Date().getFullYear(), 0, 1),
    });
  });
});