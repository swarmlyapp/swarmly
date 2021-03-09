App.comments = App.cable.subscriptions.create "MessagesChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server


  received: (data) ->
    if !!location.pathname.match("conversations/" + data.conversation_id) || !!$('li[data-conversation-id='+ data.conversation_id + ']').length
      Turbolinks.visit(location);
    #Called when there's incoming data on the websocket for this channel
  