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

    $('#select-all').on('click', function(){
      $(this).addClass('loading');
      $.ajax({
          url: Routes.worker_select_all_locations_path(),
          method: 'PUT',
          success: function(){
            window.location = window.location.pathname
          },
          error: function(jqXHR, textStatus, errorThrown){
            toastr['error'] = errorThrown;
          }
        }).complete(function(){
          $(this).removeClass('loading');
        });
    });

    $('#reset').on('click', function(){
      $(this).addClass('loading');
      $.ajax({
          url: Routes.worker_reset_locations_path(),
          method: 'PUT',
          success: function(){
            window.location = window.location.pathname
          },
          error: function(jqXHR, textStatus, errorThrown){
            toastr['error'] = errorThrown;
          }
        }).complete(function(){
          $(this).removeClass('loading');
        });
    });
  });
});
