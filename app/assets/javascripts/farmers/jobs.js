$(document).on('turbolinks:load', function(){
  $('.jobs.new, .jobs.create, .jobs.edit, .jobs.update').ready(function(){
    $('.ui.dropdown').dropdown();
    $('.range-start').calendar({
      type: 'date',
      startMode: 'month',
      endCalendar: $('.range-end'),
      initialDate: new Date()
    });

    $('.range-end').calendar({
      type: 'date',
      startMode: 'month',
      startCalendar: $('.range-start'),
      initialDate: new Date()
    });
  });

  $(".jobs.published").ready(function(){
    $(".job_live.toggle").on("click", function(){
      var id = $(this).data('job-id');
      $.ajax({
        url: Routes.farmer_job_live_path(id),
        method: "PUT",
        success: function(){
          toastr.success("You've updated the live status of your job advertisment");
        },
        error: function(){
          toastr.error("Something has gone wrong, please contact customer support");
        }
      })
    })
  });
});