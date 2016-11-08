$(document).on('turbolinks:load', function(){
  $('.locations.new').ready(function(){
    $('#locations input[type=checkbox]').on('click', function(){
      if(this.checked){
        $.ajax({
          url: Routes.worker_locations_path(),
          method: 'POST',
          data: {
            id: this.value
          },
          error: function(jqXHR, textStatus, errorThrown){
            _toastr('error', errorThrown);
          }
        })
      }else{
        $.ajax({
          url: Routes.worker_location_path(this.value),
          method: 'DELETE',
          error: function(jqXHR, textStatus, errorThrown){
            _toastr('error', errorThrown);
          }
        })
      }
    })
  });

  $('.locations.show').ready(function(){
    $('#locations input[type=radio]').on('change', function(){
      var self = this;
      $.ajax({
          url: Routes.farmer_location_path(this.value),
          method: 'PUT',
          data: {
            id: this.value
          },
          success: function(){
            _toastr('success', 'Location updated')
            $('#location-label').html($(self).data('label'));
          },
          error: function(jqXHR, textStatus, errorThrown){
            _toastr('error', errorThrown);
          }
        })
    })
  });
});
