document.addEventListener 'turbolinks:load', ->
  $("[id^=track]").click ->
    Rails.ajax
      url: '/projects/' + $(this).data('project') + '/tracks/' + $(this).data('track') + '/downloaded'
      type: 'post'
    return
