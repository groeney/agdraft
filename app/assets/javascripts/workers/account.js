$(document).on('turbolinks:load', function(){
  $('.registrations.edit').ready(function(){
    $("#worker_hidden").on("click", function(){
      var hidden = this.checked;
      $.ajax({
        url: Routes.worker_extra_details_path(),
        method: "PUT",
        data: {worker: {hidden: hidden} },
        success: function(data, textStatus, jqXHR){
          if(hidden){
            _toastr('success', "Profile is now hidden from AgDraft users");
          }else{
            _toastr('success', "Profile is now visible to AgDraft users");
          }
        },
        error: function(jqXHR, textStatus, errorThrown){
          _toastr('error', errorThrown);
        }
      })
    })
  });
});