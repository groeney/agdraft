$(document).on('turbolinks:load', function(){
  $('.unavailabilities.index').ready(function(){
    $('.ui.form').each(function(){
      var $form = $(this);
      var unavailabilityID = $form.data('id');
      var minDate = new Date();
      var unavailability, startDate, endDate;

      // var unavailabilities is set in _slot.html.erb
      if (typeof (unavailability = lookup(unavailabilities, 'id', unavailabilityID)) != 'undefined'){
        startDate = minDate = new Date(unavailability.start_date);
        endDate = new Date(unavailability.end_date);
      }

      $form.find('.range-start').calendar({
        type: 'date',
        startMode: 'month',
        minDate: minDate,
        endCalendar: $form.find('.range-end'),
      });

      $form.find('.range-end').calendar({
        type: 'date',
        startMode: 'month',
        startCalendar: $form.find('.range-start'),
      });

      $form.find('.range-start').calendar('set date', startDate);
      $form.find('.range-end').calendar('set date', endDate);

      $form.find('#delete').on('click', function(){
        if (unavailabilityID != ''){
          $.ajax({
            context: $form,
            url: Routes.worker_unavailability_path(unavailabilityID),
            method: 'DELETE',
            accepts: {
              json: 'application/json'
            },
            contentType: 'application/json',
            success: function(data, textStatus, jqXHR){
              $(this).remove();
              _toastr('success','Unavailability removed');
            },
            error: function(jqXHR, textStatus, errorThrown){
              _toastr('error', errorThrown);
            }
          });
        }
      });

      $form.find('#save').on('click', function(){
        var startDate = $form.find('.range-start').calendar('get date');
        var endDate = $form.find('.range-end').calendar('get date');

        var ajaxPath = Routes.worker_unavailabilities_path()
        var method = 'POST';
        if ($form.data('id') != ''){
          method = 'PUT';
          ajaxPath = Routes.worker_unavailability_path(unavailabilityID);
        }

        $.ajax({
          context: $form,
          url: ajaxPath,
          method: method,
          accepts: {
            json: 'application/json'
          },
          contentType: 'application/json',
          dataType: 'json',
          data: JSON.stringify({
            start_date: startDate,
            end_date  : endDate
          }),
          success: function(data, textStatus, jqXHR){
            _toastr('success','Unavailability saved!');
            if (jqXHR.status == 201){
              setTimeout(function(){
                Turbolinks.visit(location.toString());
              }, 250);
            }
          },
          error: function(jqXHR, textStatus, errorThrown){
            _toastr('error', errorThrown);
          }
        });
      });
    });
  });
});