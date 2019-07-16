document.addEventListener 'turbolinks:load', ->
  $("[id^=download_link_]").click ->
    Rails.ajax
      url: '/projects/' + $(this).data('project') + '/tracks/' + $(this).data('track') + '/downloaded'
      type: 'post'
  return
