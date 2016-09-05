$(document).on('turbolinks:load', function(){
  $('.locations.index').ready(function(){
    $('.trash.icon').on('click', function(){
      var self = this;
      $.ajax({
          url: Routes.worker_location_path($(this).data('id')),
          method: 'DELETE',
          success: function(){
            $(self).parent().remove();
          },
          error: function(jqXHR, textStatus, errorThrown){
            toastr['error'] = errorThrown;
          }
        })
    });
  });
});
