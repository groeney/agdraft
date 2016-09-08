$(document).on('turbolinks:load', function(){
  $('.farmers.edit').ready(function(){
    $('#edit_farmer').on('ajax:success', function(e, data, status, xhr){
      toastr['success']('Successfully updated!');
    }).on('ajax:error',function(e, xhr, status, error){
      toastr['error'](xhr.responseJSON.error);
    });
  });
});