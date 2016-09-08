$(document).on('turbolinks:load', function(){
  $('.qualifications.index').ready(function(){
    $('.ui.card').each(function(){

      $card = $(this);
      var resourceID, resourcePath;
      if ($card.data('resource-type') == 'certificate'){
        resourceID = $card.data('certificate-id');
        resourcePath = Routes.worker_certificate_path(resourceID);
      } else {
        resourceID = $card.data('education-id');
        resourcePath = Routes.worker_education_path(resourceID);
      }

      $card.find('#delete').on('click', function(){
        var $card = $(this).parent();
        if (typeof resourceID != 'undefined' && resourceID != ''){
          $.ajax({
            context: $card,
            url: resourcePath,
            method: 'DELETE',
            accepts: {
              json: 'application/json'
            },
            contentType: 'application/json',
            success: function(){
              $card.remove();
              toastr['success']("Successfully deleted");
            },
            error: function(jqXHR, textStatus, errorThrown){
              toastr['error'](errorThrown);
            }
          });
        }
      });
    });

    $('.tabular.menu .item').tab();
  });
});