$(document).on('turbolinks:load', function(){
  $('.onboard.job_categories, .job_categories.index').ready(function(){
    $('.image.job-category').popup({
      inline: true,
      on: 'click',
      position: 'bottom center',
      onShow: function($module){
        if ($($module).data('selected')){
          return false
        }
      }
    });

    $('.job-category').on('click', function() {
      var jobCategoryID = $(this).data('id');
      if ($(this).data('selected')){
        $.ajax({
          context: this,
          url: Routes.worker_job_category_path(jobCategoryID),
          method: 'DELETE',
          accepts: {
            json: 'application/json'
          },
          contentType: 'application/json',
          dataType: 'json',
          success: function(data, textStatus, jqXHR){
            $(this).data('selected', false);
            $(this).removeClass('selected');
            $('.item[data-job-category-id=' + jobCategoryID + ']').css('display', 'none');
          },
          error: function(jqXHR, textStatus, errorThrown){
            _toastr('error', errorThrown);
          }
        })
      } else {
        $.ajax({
          context: this,
          url: Routes.worker_job_categories_path(),
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
            $(this).data('selected', true);
            $(this).addClass('selected');
            $('.item[data-job-category-id=' + jobCategoryID + ']').css('display', 'block');
          },
          error: function(jqXHR, textStatus, errorThrown){
            _toastr('error', errorThrown);
          }
        });
      }
    });

    $('.ui.label.skill').on('click', function () {
      var skillID = $(this).data('id');
      if ($(this).data('selected')){
        $.ajax({
          context: this,
          url: Routes.worker_skill_path(skillID),
          method: 'DELETE',
          accepts: {
            json: 'application/json'
          },
          contentType: 'application/json',
          dataType: 'json',
          success: function(data, textStatus, jqXHR){
            $(this).removeClass('teal');
            $(this).data('selected', false);
            $('.item[data-skill-id=' + skillID + ']').css('display', 'none');
          },
          error: function(jqXHR, textStatus, errorThrown){
            _toastr('error', errorThrown);
            $(this).toggleClass(activeClass);
          }
        });
      }else{
        $.ajax({
          context: this,
          url: Routes.worker_skills_path(),
          method: 'POST',
          accepts: {
            json: 'application/json'
          },
          contentType: 'application/json',
          dataType: 'json',
          data: JSON.stringify({
            id: skillID
          }),
          success: function(data, textStatus, jqXHR){
            $(this).addClass('teal');
            $(this).data('selected', true);
            $('.ui.label[data-skill-id=' + skillID + ']').css('display', 'inline-block');
          },
          error: function(jqXHR, textStatus, errorThrown){
            _toastr('error', errorThrown);
            $(this).toggleClass(activeClass);
          }
        });
      }
    });
  });
});