define (require, exports, module) ->
  User = require './User'
  Room = require './Room'

  class Client
    constructor: () ->
      @callbacks = []
      @socket = io.connect()
     @socket.on 'newUser', (data) =>
        @me = new User(@socket, data['id'], 'Name')
        for callback in @callbacks
          callback()
      @socket.on 'newRoom', (data) =>
        if data['settings']['id'] == -1
          @room = null
        else
          @room = new Room(@socket, data['settings'])

      @onReady () =>
        @setup()

    onReady: (callback) ->
      @callbacks.push callback

    setup: () ->
      console.log 'Connected'
      console.log @me
      @me.changeRoom(3)

  module.exports = Client