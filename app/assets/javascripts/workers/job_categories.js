$(document).on('turbolinks:load', function(){
  $('.onboard.job_categories, .job_categories.index').ready(function(){
    var activeClass = 'red';
    $('.ui.link.card.job-category').on('click', function() {
      var jobCategoryID = $(this).data('id');
      var selected = $(this).data('selected');
      if ($(this).hasClass(activeClass)){
        $.ajax({
          context: this,
          url: jobCategoriesPath + jobCategoryID,
          method: 'DELETE',
          accepts: {
            json: 'application/json'
          },
          contentType: 'application/json',
          dataType: 'json',
          success: function(data, textStatus, jqXHR){
            $(this).toggleClass(activeClass);
          },
          error: function(jqXHR, textStatus, errorThrown){
            toastr['error'](errorThrown);
          }
        })
      } else {
        $.ajax({
          context: this,
          url: jobCategoriesPath,
          method: 'POST',
          accepts: {
            json: 'application/json'
          },
          contentType: 'application/json',
          dataType: 'json',
          data: JSON.stringify({
            id: jobCategoryID
          }),
          success: function(data, textStatus, jqXHR){
            $(this).toggleClass(activeClass);
          },
          error: function(jqXHR, textStatus, errorThrown){
            toastr['error'](errorThrown);
          }
        })
      }
    });
  });
});