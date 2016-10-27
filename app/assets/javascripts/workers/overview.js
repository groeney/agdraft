$(document).on('turbolinks:load', function(){
  $('.overview.index').ready(function(){
    $('.ui.rating').rating();
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

    $('.apply-for-job').on('click', function(e){
      e.preventDefault();
      var $button = $(this);
      var jobID = $button.data('job-id');
      $button.addClass('disabled');
      $.ajax({
        url: Routes.worker_express_interest_path(jobID),
        method: 'POST',
        success: function(data, status){
          toastr.success('You\'ve successfully applied to this job');
        },
        error: function(jqXHR, textStatus, errorThrown){
          $button.removeClass('disabled');
          toastr.error(errorThrown);
        }
      })
    });
  });
});