# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  $('.toggle-employment-records').click (event) ->
    event.preventDefault()
    $('.employment-records').toggle()
#    $ console.log "GOT HERE"

  $('.toggle-education').click (event) ->
    event.preventDefault()
    $('.education').toggle()

  $('.toggle-ojt').click (event) ->
    event.preventDefault()
    $('.ojt').toggle()

  $('.toggle-awards').click (event) ->
    event.preventDefault()
    $('.awards').toggle()

  $('.toggle-skills').click (event) ->
    event.preventDefault()
    $('.skills').toggle()

  $('.toggle-activities').click (event) ->
    event.preventDefault()
    $('.activities').toggle()

  $('.toggle-references').click (event) ->
    event.preventDefault()
    $('.references').toggle()

  $ ->
    setTimeout (->
      $('.notice').slideUp 500
      $('.alert').slideUp 500
      return
    ), 5000
    return