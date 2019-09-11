# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
document.addEventListener 'play', ((e) ->
  audios = document.getElementsByTagName('audio')
  i = 0
  len = audios.length
  while i < len
    if audios[i] != e.target
      audios[i].pause()
    i++
  return
), true
