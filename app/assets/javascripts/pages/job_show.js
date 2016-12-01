$(document).on('turbolinks:load', function(){
  $('.jobs.show').ready(function(){
    $('.rating').rating('disable');
    $('.tabular.menu .item').tab();
    jobID = /^\/jobs\/[0-9]*/.exec(window.location.pathname)[0].split('/')[2];
    $('.apply-for-job').on('click', function(){
      var $button = $(this);
      $('.apply-for-job').addClass('disabled'); // more than one button on page
      $.ajax({
        url: Routes.worker_express_interest_path(jobID),
        method: 'POST',
        success: function(data, status){
          _toastr('success', 'You\'ve successfully applied to this job');
          $('.apply-for-job').text('Applied');
        },
        error: function(jqXHR, textStatus, errorThrown){
          $button.removeClass('disabled');
          _toastr('error', errorThrown);
        }
      })
    });

    $('.fb-share-button').on('click', function(){
      FB.ui({
        method: 'share',
        href: $(this).data('href'),
        quote: $(this).data('job-title')
      }, function(response){});
    });
  });
});