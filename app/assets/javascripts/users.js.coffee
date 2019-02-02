# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  $('.toggle-employment-records').click (event) ->
    toggle_text(event, 'Hide Employment History Section', 'Show Employment History Section', '.toggle-employment-records')
    $('.employment-records').toggle()

  $('.toggle-education').click (event) ->
    toggle_text(event, 'Hide Education Section', 'Show Education Section', '.toggle-education')
    $('.education').toggle()

  $('.toggle-ojt').click (event) ->
    toggle_text(event, 'Hide On The Job Experience Section', 'Show On The Job Experience Section', '.toggle-ojt')
    $('.ojt').toggle()

  $('.toggle-awards').click (event) ->
    toggle_text(event, 'Hide Awards Section', 'Show Awards Section', '.toggle-awards')
    $('.awards').toggle()

  $('.toggle-skills').click (event) ->
    toggle_text(event, 'Hide Skills Section', 'Show Skills Section', '.toggle-skills')
    $('.skills').toggle()

  $('.toggle-activities').click (event) ->
    toggle_text(event, 'Hide Activities Section', 'Show Activities Section', '.toggle-activities')
    $('.activities').toggle()

  $('.toggle-references').click (event) ->
    toggle_text(event, 'Hide References Section', 'Show References Section', '.toggle-references')
    $('.references').toggle()

  # toggle button text between Hide & SHow and change color of button if Hide or Show
  toggle_text = (event, text1, text2, this_class) ->
    event.preventDefault()
    if event.currentTarget.value == text1
      event.currentTarget.value = text2
    else
      event.currentTarget.value = text1
    document.querySelector(this_class).classList.toggle('show-button')

  $ ->
    setTimeout (->
      $('.notice').slideUp 500
      $('.alert').slideUp 500
      return
    ), 5000
    return

