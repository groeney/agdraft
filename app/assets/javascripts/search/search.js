$(document).on('turbolinks:load', function(){
  $('.search.workers').ready(function(){

    $('.ui.star.rating').rating({
      interactive: false,
      maxRating: 5
    });

    $('.ui.dropdown').dropdown();

    $('.range-start').calendar({
      type: 'date',
      startMode: 'month',
      endCalendar: $('.range-end'),
      minDate: new Date(),
    });

    $('.range-end').calendar({
      type: 'date',
      startMode: 'month',
      startCalendar: $('.range-start'),
    });
  });
});