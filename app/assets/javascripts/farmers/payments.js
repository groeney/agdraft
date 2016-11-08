$(document).on('turbolinks:load', function(){
  $('.payments.show').ready(function(){
    Stripe.setPublishableKey(stripe_publishable_key);

    var $form = $('#payment-form');

    $("#add-payment").on("click", function(){
      $form.toggle();
      $(this).hide();
    });

    $("#cancel").on("click", function(e){
      e.preventDefault();
      $form.toggle();
      $("#add-payment").show();
    });

    $form.submit(function(event) {
      event.preventDefault();
      // Disable the submit; button to prevent repeated clicks:
      $form.find('.submit').prop('disabled', true);
      $form.find('#cancel').prop('disabled', true);
      $("#payment-verify-loading").show();
      $("#card-details").hide();

      $form.find('#payment-error').hide();

      // Request a token from Stripe:
      Stripe.card.createToken($form, stripeResponseHandler);

      // Prevent the form from being submitted:
      return false;
    });

    function stripeResponseHandler(status, response) {
      // Grab the form:
      var $form = $('#payment-form');

      if (response.error) { // Problem!

        // Show the errors on the form:
        $form.find('#payment-error').text(response.error.message).show();
        $form.find('.submit').prop('disabled', false); // Re-enable submission
        $form.find('#cancel').prop('disabled', false);
        $("#payment-verify-loading").hide();
        $("#card-details").show();
      } else { // Token was created!

        // Get the token ID:
        var token = response.id;

        $.ajax({
          url: Routes.farmer_update_payment_path(),
          method: "PUT",
          data: {token: token},
          success: function(){
            _toastr('success', "Successfully updated your payment information");
            $form.find('.submit').prop('disabled', false);
            $form.find('#cancel').prop('disabled', false);
            $form.hide();
            $form.find("input[type=text]").val("")
            $("#payment-verify-loading").hide();
            $("#card-details").show();
            $("#payment-status .warning").addClass('hidden');
            $("#payment-status .success").removeClass('hidden');
            $("#add-payment").show();

          },
          error: function(){
            _toastr('error',"The form of payment you provided was invalid, please use a different card");
            setTimeout(function(){location.reload()}, 4000);
          }
        })
      }
    };
  });
});