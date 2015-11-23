var formHelpers = {
  sections: [],

  init: function() {
    var sections = this.sections;
    $.each($('form section'), function(key, value) {
      sections.push(key);
    });
  },

  nextSection: function(currentID) {
    var targetID = currentID.data('id') + 1,
        $currentSection = $('section[data-id="' + currentID.data('id') + '"]'),
        $nextSection = $('section[data-id="' + targetID + '"]');

    $.each($('.active input'), function() {
      $(this).attr('required', true);
    });

    $currentSection.fadeOut('fast', function() {
      $(this).removeClass('active');

      $nextSection.fadeIn('fast', function() {
        $(this).addClass('active');
        $('input:first-of-type').focus();
      });
    });
  },

  previousSection: function(currentID) {
    var targetID = currentID.data('id') - 1;

    $('section[data-id="' + currentID.data('id') + '"]').fadeOut('fast', function() {
      $(this).removeClass('active');

      $('section[data-id="' + targetID + '"]').fadeIn('fast', function() {
        $(this).addClass('active');
      });
    });
  }
};

var ready = function() {
  formHelpers.init();
  var formData = $('form').serialize(),
      environment = $('body').hasClass('development') ? 'development' : 'production'; // for third-party tool UIDs

  var mixpanelUIDs = {
    development: 'bbb040eaccfc483f50cfa0de51972fce', // 'staging' mixpanel project UID
    production: '30ffbd5584eccdbb0ca079552d487384' // production mixpanel project UID
  }

  // Initialize Mixpanel
  //mixpanel.init(mixpanelUIDs[environment], { cookie_name: 'moosedata' });

  var validate = $('form').validate({
    errorElement: 'em',
    errorLabelContainer: '.error',
    rules: {
      your_name: {
        required: true
      },
      company_name: {
        required: true
      },
      email: {
        required: true,
        email: true
      },
      password: {
        required: true
      }
    },
    messages: {
      your_name: "We need your name to continue",
      company_name: "We need your company name! You can always change it later",
      email: {
        required: "We need your email to continue",
        email: "That doesn't look like a valid email"
      },
      password: "You'll want a password!",
    },
    submitHandler: function(form) {
      var data = {},
          completedSection = $('form .active').data('id');

      // Grab values from form section and prepare object for POST
      $('form .active input').each(function() {
        var property = this.attributes.name.value,
            value = this.value;

        data[property] = value;
        $(data).serialize();
      });

      // Mixpanel
      // Track completed funnel steps
      //mixpanel.track("Completed funnel step (" + completedSection + ")", data);

      // If our user has given us their email, identify them
      if(completedSection === 3) {
        //mixpanel.identify($('input[type="email"]').val());
        // mixpanel.people.set({
        //   "$email": $('input[type="email"]').val(),
        //   "$created": new Date(),
        //   "company": $('input#company_name').val()
        // });
      }

      $.ajax({
        type: 'POST',
        url: 'api/v1/funnel/step' + completedSection,
        data: data,
        dataType: 'JSON',
        async: true,
        beforeSend: function(xhr) {
          xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
        },
        success: function(data) {
          $("#error-message").hide();

          // If user has reached the last step, redirect to app landing
          if($('form .active').data('action') == 'account') {
            window.location.href = window.location.origin + "/dashboard/launch/upload_logo";
          // ...otherwise, skip to next form section
          } else {
            formHelpers.nextSection($('.active'));
          }
        },
        error: function(request, status, error) {
          $("#error-message").show();
        }
      });
    }
  });

  $('.previous').on('click', function(e) {
    e.preventDefault(); // don't submit the form
    formHelpers.previousSection($('.active'));
  });

  $('.continue').on('click', function(e) {
    if(validate.form()) {
      //formHelpers.nextSection($('.active'));
    }
  });
};

$(document).ready(ready);
$(document).on('page:load', ready);
