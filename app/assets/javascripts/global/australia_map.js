$(document).on('turbolinks:load', function(){
  $('.locations.new, .locations.show').ready(function(){
    $('svg path').on('click', function(){
      $('svg path').each(function(){this.style.fill = 'rgb(75, 160, 0)'})
      this.style.fill = 'brown';
      $('#state-header').html(this.id + ' Regions');
      $('[data-state]').hide();
      $('[data-state=' + this.id + ']').show();
    });
    $('svg path').mouseover(function(e){
      this.style.opacity = 0.7;
    })
    $('svg path').mouseout(function(e){
      this.style.opacity = 1;
    })

    $('#state-dropdown').dropdown({
      onChange: function(value, text){
        $('#state-header').html(value + ' Regions');
        $('[data-state]').hide();
        $('[data-state=' + value + ']').show();  
      }
    });
  });

  var displayState = $('#location-selector').data('display-state');

  $('#' + displayState).click();
});