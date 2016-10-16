$(document).on('turbolinks:load', function(){
  $('.reviews.new, .reviews.create').ready(function(){
    $('.ui.star.rating').rating({
      maxRating: 5
    });
    var $form = $('#new_review');
    $form.submit(function(event){
      var rating = $('.ui.star.rating').rating('get rating');
      $('<input />').attr('type', 'hidden')
                .attr('name', 'review[rating]')
                .attr('value', rating)
                .appendTo(this);
      return true
    });
  });

  $('.reviews.index_of, .reviews.index_by').ready(function(){
    $('.ui.star.rating').rating({
      interactive: false,
      maxRating: 5
    });
  });
});