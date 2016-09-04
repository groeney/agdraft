$(document).on("turbolinks:load", function(){
  var activeClass = 'red';
  $('.ui.link.card.skill').on('click', function() {
    var skillID = $(this).data('id');
    var selected = $(this).data('selected');
    if ($(this).hasClass(activeClass)){
      $.ajax({
        context: this,
        url: skillsPath + skillID,
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
          toastr['error'](errorThrown)
        }
      })
    } else {
      $.ajax({
        context: this,
        url: skillsPath,
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
          $(this).toggleClass(activeClass);
        },
        error: function(jqXHR, textStatus, errorThrown){
          toastr['error'](errorThrown)
        }
      })
    }
  });
})
