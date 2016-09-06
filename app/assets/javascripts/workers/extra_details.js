$(document).on('turbolinks:load', function(){
  $('.extra_details.show').ready(function(){
    $('.ui.dropdown').dropdown();

    $('#edit_worker_' + worker.id).on('ajax:success', function(e, data, status, xhr){
      toastr['success']('Worker successfully updated!');
    }).on('ajax:error',function(e, xhr, status, error){
      toastr['error'](xhr.responseJSON.error);
    });
  });
});