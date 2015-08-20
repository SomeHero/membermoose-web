# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
formHelpers =
  sections: []
  init: ->
    sections = @sections
    $.each $('form section'), (key, value) ->
      sections.push key
      return
    return
  nextSection: (currentID) ->
    targetID = currentID.data('id') + 1
    $currentSection = $('section[data-id="' + currentID.data('id') + '"]')
    $nextSection = $('section[data-id="' + targetID + '"]')
    $.each $('.active input'), ->
      $(this).attr 'required', true
      return
    $currentSection.fadeOut 'fast', ->
      $(this).removeClass 'active'
      $nextSection.fadeIn 'fast', ->
        $(this).addClass 'active'
        $('input:first-of-type').focus()
        return
      return
    return
  previousSection: (currentID) ->
    targetID = currentID.data('id') - 1
    $('section[data-id="' + currentID.data('id') + '"]').fadeOut 'fast', ->
      $(this).removeClass 'active'
      $('section[data-id="' + targetID + '"]').fadeIn 'fast', ->
        $(this).addClass 'active'
        return
      return
    return

ready = ->
  formHelpers.init()
  formData = $('form').serialize()
  environment = if $('body').hasClass('development') then 'development' else 'production'
  # for third-party tool UIDs
  mixpanelUIDs =
    development: 'bbb040eaccfc483f50cfa0de51972fce'
    production: '30ffbd5584eccdbb0ca079552d487384'
  # Initialize Mixpanel
  #mixpanel.init mixpanelUIDs[environment], cookie_name: 'moosedata'
  validate = $('form').validate(
    errorElement: 'em'
    errorLabelContainer: '.error'
    rules:
      your_name: required: true
      company_name: required: true
      email:
        required: true
        email: true
      password: required: true
    messages:
      your_name: 'We need your name to continue'
      company_name: 'We need your company name! You can always change it later'
      email:
        required: 'We need your email to continue'
        email: 'That doesn\'t look like a valid email'
      password: 'You\'ll want a password!'
    submitHandler: (form) ->
      data = {}
      completedSection = $('form .active').data('id')
      # Grab values from form section and prepare object for POST
      $('form .active input').each ->
        property = @attributes.name.value
        value = @value
        data[property] = value
        $(data).serialize()
        return
      # Mixpanel
      # Track completed funnel steps
      # mixpanel.track 'Completed funnel step (' + completedSection + ')', data
      # # If our user has given us their email, identify them
      # if completedSection == 3
      #   mixpanel.identify $('input[type="email"]').val()
      #   mixpanel.people.set
      #     '$email': $('input[type="email"]').val()
      #     '$created': new Date
      #     'company': $('input#company_name').val()
      $.ajax
        type: 'POST'
        url: '/get_started/' + $('form .active').data('action')
        data: data
        dataType: 'JSON'
        async: true
        beforeSend: (xhr) ->
          xhr.setRequestHeader 'X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')
          return
        success: (data) ->
          $('#error-message').hide()
          # If user has reached the last step, redirect to app landing
          if $('form .active').data('action') == 'account'
            window.location.href = window.location.origin
            # ...otherwise, skip to next form section
          else
            formHelpers.nextSection $('.active')
          return
        error: (request, status, error) ->
          $('#error-message').show()
          return
      return
  )
  $('.previous').on 'click', (e) ->
    e.preventDefault()
    # don't submit the form
    formHelpers.previousSection $('.active')
    return
  $('.continue').on 'click', (e) ->
    if validate.form()
      #formHelpers.nextSection($('.active'));
    else
    return
  return

$(document).ready ready
$(document).on 'page:load', ready
