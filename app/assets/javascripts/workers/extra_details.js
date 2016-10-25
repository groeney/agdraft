$(document).on('turbolinks:load', function(){
  $('.extra_details.show').ready(function(){
    $('.ui.dropdown').dropdown();
    $('.ui.calendar').calendar({
      type: 'date',
      startMode: 'year',
      maxDate: new Date(),
    });

    $('#edit-worker').on('ajax:success', function(e, data, status, xhr){
      toastr['success']('Worker successfully updated!');
      window.scrollTo(0,0);
    }).on('ajax:error',function(e, xhr, status, error){
      toastr['error'](xhr.responseJSON.error);
    });
  });

  $('#edit-worker .worker_visa select').on("change", function(){
    if(this.value == 'Working Holiday Visa' || this.value == 'Tourist Visa'){
      $('#edit-worker .worker_visa_number').show()
      $('#edit-worker .worker_visa_number input').focus();
    }else{
      $('#edit-worker .worker_visa_number').hide();
    }
  });

  // Display hidden visa number on page load if applicable
  var visa = $('#edit-worker .worker_visa select')[0].value
  if(visa == 'Working Holiday Visa' || visa == 'Tourist Visa'){
    $('#edit-worker .worker_visa_number').show()
  }
});