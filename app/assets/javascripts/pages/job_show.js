$(document).on('turbolinks:load', function(){
  $('.jobs.show').ready(function(){
    $(".rating").rating('disable');
    jobID = /^\/jobs\/[0-9]*/.exec(window.location.pathname)[0].split("/")[2]
    $("#apply-for-job").on("click", function(){
      var button = $(this);
      button.addClass("disabled");
      $.ajax({
        url: Routes.worker_express_interest_path(jobID),
        method: "POST",
        success: function(data, status){
          toastr.success("You've successfully applied to this job");
        },
        error: function(jqXHR, textStatus, errorThrown){
          button.removeClass("disabled");
          toastr.error(errorThrown);
        }
      })
    });
  });
});