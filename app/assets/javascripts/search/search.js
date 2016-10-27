$(document).on('turbolinks:load', function(){
  $('.search.jobs').ready(function(){
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
      });
    });
  });
  $('.search.workers, .search.jobs').ready(function(){
    $('.ui.star.rating').rating({
      interactive: false,
      maxRating: 5
    });

    $('.ui.dropdown').dropdown();

    $('.range-start').calendar({
      type: 'date',
      startMode: 'month',
      endCalendar: $('.range-end'),
      minDate: new Date(),
    });

    $('.range-end').calendar({
      type: 'date',
      startMode: 'month',
      startCalendar: $('.range-start'),
    });
  });
});