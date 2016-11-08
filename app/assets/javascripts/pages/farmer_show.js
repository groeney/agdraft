$(document).on('turbolinks:load', function(){
  $('.farmers.show').ready(function(){
    $('.ui.rating').rating('disable');
    $('.tabular.menu .item').tab();
    $('.apply-for-job').on('click', function(e){
      e.preventDefault();
      var $button = $(this);
      var jobID = $button.data('job-id');
      $button.addClass('disabled');
      $.ajax({
        url: Routes.worker_express_interest_path(jobID),
        method: 'POST',
        success: function(data, status){
          _toastr('success', 'You\'ve successfully applied to this job');
        },
        error: function(jqXHR, textStatus, errorThrown){
          $button.removeClass('disabled');
          _toastr('error', errorThrown);
        }
      });
    });
  });
});