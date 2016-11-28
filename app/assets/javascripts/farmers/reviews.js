$(document).on('turbolinks:load', function(){
  $('.reviews.index_of, .reviews.index_by').ready(function(){
    $('.ui.star.rating').rating({
      interactive: false,
      maxRating: 5
    });
  });
});