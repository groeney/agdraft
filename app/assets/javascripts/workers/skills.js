$(document).on('turbolinks:load', function(){
  $('.onboard.skills, .skills.index').ready(function(){
    var activeClass = 'disabled';
    $('.label-list .label').on('click', function() {
      var skillID = $(this).data('id');
      if ($(this).hasClass(activeClass)){
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
            
          },
          error: function(jqXHR, textStatus, errorThrown){
            toastr['error'](errorThrown);
            $(this).toggleClass(activeClass);
          }
        });
      } else {
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
            
          },
          error: function(jqXHR, textStatus, errorThrown){
            toastr['error'](errorThrown);
            $(this).toggleClass(activeClass);    
          }
        });
      }
      $(this).toggleClass(activeClass);
    });
  });
});
