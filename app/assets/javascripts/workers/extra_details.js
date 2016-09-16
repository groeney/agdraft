$(document).on('turbolinks:load', function(){
  $('.extra_details.show').ready(function(){
    $('.ui.dropdown').dropdown();
    $('.ui.calendar').calendar({
      type: 'date',
      startMode: 'year'
    });

    $('#edit-worker').on('ajax:success', function(e, data, status, xhr){
      toastr['success']('Worker successfully updated!');
    }).on('ajax:error',function(e, xhr, status, error){
      toastr['error'](xhr.responseJSON.error);
    });
  });
});