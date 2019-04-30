class @Comment
  @add_atwho = ->
    $('#comment_description').atwho
      at: '@'
      displayTpl:"<li class='mention-item' data-value='(${name}'>${name}</li>",
      callbacks: remoteFilter: (query, callback) ->
        if (query.length < 1)
          return false
        else
          $.getJSON '/mentions', { q: query }, (data) ->
            callback data

jQuery ->
  Comment.add_atwho()