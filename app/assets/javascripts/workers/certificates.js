$(document).on('turbolinks:load', function(){
  $('.certificates.new, .certificates.create').ready(function(){
    $('.js-calendar').calendar({
      type: 'date',
      startMode: 'year',
      maxDate: new Date(),
      initialDate: new Date(new Date().getFullYear(), 0, 1),
    });
  });
});