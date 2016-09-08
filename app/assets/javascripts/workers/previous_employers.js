$(document).on('turbolinks:load', function(){
  $('.previous_employers.index').ready(function(){
    $('.ui.card').each(function(){
      $card = $(this);
      var previousEmployerID = $card.data('previous-employer-id');
      $card.find('#delete').on('click', function(){
        if (typeof previousEmployerID != 'undefined' && previousEmployerID != ''){
          $.ajax({
            context: $card,
            url: Routes.worker_previous_employer_path(previousEmployerID),
            method: 'DELETE',
            accepts: {
              json: 'application/json'
            },
           success: function(){
              $card.remove();
              toastr['success']("Previous employment successfully deleted");
            },
            contentType: 'application/json',
            error: function(jqXHR, textStatus, errorThrown){
              toastr['error'](errorThrown);
            }
          });
        }
      });

    })
  });

  $('.previous_employers.new, .previous_employers.create').ready(function(){
    $('.range-start').calendar({
      type: 'date',
      startMode: 'year',
      endCalendar: $('.range-end'),
      maxDate: new Date(),
      initialDate: new Date(new Date().getFullYear(), 0, 1),
    });

    $('.range-end').calendar({
      type: 'date',
      startMode: 'year',
      startCalendar: $('.range-start'),
      maxDate: new Date(),
      initialDate: new Date(new Date().getFullYear(), 0, 1),
    });
  });
});