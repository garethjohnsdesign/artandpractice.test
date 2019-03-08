Stripe.setPublishableKey(window.STRIPE_PUBLISHABLE_KEY);

function getTransactionFeeCents(amount) {
  return isNaN(amount) ? 0 : Math.round((amount * 0.029) + 30, 2);
}

$(function() {
  var $form = $('#payment-form');
  var $amountManual = $form.find('input[name="amount-manual"]');
  var $amountSelect = $form.find('input[name="amount-select"]');
  var $donationType = $form.find('input[name="donation-type"]');
  var $creditCardExpYear = $form.find('select[name="expiry-year"]');
  var $donationProxyName = $form.find('input[name="donation-proxy-name"]');
  var $donationListingName = $form.find('input[name="preferred-annual-report-listing"]');
  var $transactionFeeAmount = $form.find('.transaction-fee-amount');

  var i = 0, 
      currentYear = (new Date()).getFullYear(),
      year;
      
  while (i < 21) {
    year = currentYear + i;
    $creditCardExpYear.append('<option value="' + year + '">' + year + '</option>');
    i++;
  }

  $amountManual.on('keyup', function() {
    $amountSelect.prop('checked', false);
    updateTransactionFeeCopy();
  });

  $amountSelect.on('click', function() {
    $amountManual.val('');
    updateTransactionFeeCopy();
  });

  function getAmount() {
    return !!$amountManual.val() ? 
      (parseInt($amountManual.val().replace(/\D/g, '')) * 100) : 
      ($amountSelect.filter(':checked').val() * 100);
  }

  function updateTransactionFeeCopy() {
    var transactionFee = (getTransactionFeeCents(getAmount()) / 100).toFixed(2);

    if (transactionFee > 0) {
      $transactionFeeAmount.html('($' + transactionFee + ') ');
    } else {
      $transactionFeeAmount.html('');
    }
  }

  $donationType.on('click', function(e) {
    $donationProxyName.toggle(e.target.value === 'proxy').val('');
    $donationListingName.toggle(e.target.value === 'public').val('');
  });

  $form.submit(function(event) {
    $form.find('.submit').prop('disabled', true).val('PROCESSING...');
    $('.has-validation-error').removeClass('has-validation-error');

    var formData = $form.serialize();
    var validationErrors = validate(formData);

    if (validationErrors.length > 0) {
      showErrors(
        validationErrors.map(function(validationError) { return validationError[1]; }),
        validationErrors.map(function(validationError) { return validationError[0]; })
      );
      $form.find('.submit').prop('disabled', false).val('SUBMIT DONATION');
    } else {
      Stripe.card.createToken($form, stripeResponseHandler);
    }

    return false;
  });

  $('.show-other-ways').on('click', function(e) {
    e.preventDefault();

    $('.donate-container__form').toggle();
    $('.donate-container__other-ways').toggle();
  })
});

var validations = {
  'amount-select': [
    {
      getValue: function() {
        return $('input[name="amount-select"]:checked').val();
      },
      errorInputName: 'amount-manual',
      validator: function(value) {
        return !value && $('input[name="amount-manual"]').val() === '';
      },
      message: 'Donation amount must be specified'
    }
  ],
  'amount-manual': [
    {
      validator: function(value) {
        return parseFloat(value) && !Number.isInteger(parseFloat(value));
      },
      message: 'Donation amount must be in whole dollars'
    },
    {
      validator: function(value) {
        return Number.isInteger(parseFloat(value)) && parseFloat(value) < 5;
      },
      message: 'Donation amount must be more than 5 dollars'
    }
  ],
  'donation-type': [
    {
      getValue: function() {
        return $('input[name="donation-type"]:checked').val();
      },
      errorInputName: 'preferred-annual-report-listing',
      validator: function(value) {
        return (value === 'public' && $('[name="preferred-annual-report-listing"]').val() === '')
      },
      message: 'Annual Report Listing Name must be specified'
    },
    {
      getValue: function() {
        return $('input[name="donation-type"]:checked').val();
      },
      errorInputName: 'donation-proxy-name',
      validator: function(value) {
        return (value === 'proxy' && $('[name="donation-proxy-name"]').val() === '')
      },
      message: 'Annual Report Listing Name must be specified'
    }
  ],
  'card-number': [
    {
      validator: function(value) { return value === '' },
      message: 'Credit Card number is required'
    }
  ],
  'expiry-month': [
    {
      validator: function(value) { return value === '' },
      message: 'Credit Card Expiration Month is required'
    }
  ],
  'expiry-year': [
    {
      validator: function(value) { return value === '' },
      message: 'Credit Card Expiration Year is required'
    }
  ],
  'cvv': [
    {
      validator: function(value) { return value === '' },
      message: 'Credit Card CVV is required'
    }
  ],
  'first-name': [
    {
      validator: function(value) { return value === '' },
      message: 'First name is required'
    }
  ],
  'last-name': [
    {
      validator: function(value) { return value === '' },
      message: 'Last name is required'
    }
  ],
  'email': [
    {
      validator: function(value) { return value === '' },
      message: 'Email address is required'
    }
  ],
  'address-street-1': [
    {
      validator: function(value) { return value === '' },
      message: 'Address is required'
    }
  ],
  'address-zip-code': [
    {
      validator: function(value) { return value === '' },
      message: 'Zip code is required'
    }
  ],
  'address-city': [
    {
      validator: function(value) { return value === '' },
      message: 'City is required'
    }
  ],
  'address-state': [
    {
      validator: function(value) { return value === '' },
      message: 'State is required'
    }
  ]
}

function validate(formData) {
  var errors = [];

  $.each(validations, function(name, validationObjects) {
    $.each(validationObjects, function(index, validationObject) {
      var value = validationObject.getValue ? validationObject.getValue() : $('[name="' + name + '"]').val();
      var errorInputName = validationObject.errorInputName || name;

      if (validationObject.validator(value)) {
        errors.push([errorInputName, validationObject.message]);
      }
    })
  });

  return errors
}

var $errorsAlert = $('#payment-form .subscribe-form__notification-danger');

function showErrors(errors, inputNames) {
  var errorsEls = '';
  $.each(errors, function(index, err) {
    errorsEls += '<li>' + err + '</li>';
  });
  if (inputNames) {
    $.each(inputNames, function(index, inputName) {
      $('[name="' + inputName + '"]').addClass('has-validation-error');
    })
  }
  $errorsAlert.find('ul').html(errorsEls);
  $errorsAlert.show();

  $('html, body').animate({
    scrollTop: $errorsAlert.offset().top - 125
  }, 500);
}

function stripeResponseHandler(status, response) {
  var $form = $('#payment-form');

  if (response.error) {
    showErrors([response.error.message]);
    $form.find('.submit').prop('disabled', false).val('SUBMIT DONATION');
  } else {
    var token = response.id;
    var amount = ($form.find('input[name="amount-manual"]').val() * 100) || ($form.find('input[name="amount-select"]').filter(':checked').val() * 100);

    if ($form.find('[name="include-transaction-fee"]:checked').length > 0) {
      amount = amount + getTransactionFeeCents(amount);
    }

    $form.append($('<input type="hidden" name="stripeToken">').val(token));
    $form.append($('<input type="hidden" name="amount">').val(amount));

    var formData = $form.serialize();

    $.post(window.API_BASE_URL + '/charge', formData)
      .done(function() {
        $errorsAlert.hide();
        $form.find('.submit').prop('disabled', false).val('SUBMIT DONATION');
        $('.donate-container__form').hide();
        $('.donate-container__success').show();
        $('html, body').animate({
          scrollTop: 0
        }, 500);
      })
      .fail(function() {
        $form.find('[name="stripeToken"]').remove();
        $form.find('[name="amount"]').remove();
        showErrors(['Donation could not be processed. Please try again.']);
        $form.find('.submit').prop('disabled', false).val('SUBMIT DONATION');
      });
  }
};

var $city = $('input[name="address-city"]');
var $state = $('input[name="address-state"]');
$('input[name="address-zip-code"]').on('change', function(e) {
  var value = e.target.value;

  if (value.length === 5) {
    $.get('https://api.zippopotam.us/us/' + value)
      .done(function(response) {
        var place = response.places[0];

        $city.val(place['place name']);
        $state.val(place['state abbreviation']);
      })
  } else {
    $city.val('');
    $state.val('');
  }
})