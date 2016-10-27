$(document).on('turbolinks:load', function(){
  $('.overview.index').ready(function(){
    $('.block-job').on('click', function(e){
      e.preventDefault();
      $.ajax({
        context: this,
        url: Routes.block_job_recommendation_path($(this).data('recommendation-id')),
        method: 'PUT',
        success: function(){
          $(this).closest('.ui.card').hide();
        },
        error: function(jqXHR, textStatus, errorThrown){
          toastr['error'] = errorThrown;
        }
      });
    });
  });
});