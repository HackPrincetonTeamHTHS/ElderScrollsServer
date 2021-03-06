if !window?
  `var define = require('amdefine')(module)`
else
  define = window.define

define (require, exports, module) ->
  User = require './User'
  Room = require './Room'

  class Client
    constructor: () ->
      @callbacks = []
      @updateCallbacks = {}
      @socket = io.connect()

      @socket.on 'newUser', (data) =>
        @me = new User @socket, data['id'], 'Anonymous'
        for callback in @callbacks
          callback()
        return

      @socket.on 'newRoom', (data) =>
        if @room?
          @room.close()
        @room = new Room @socket, data['settings']
        @rebindUpdateCallbacks()

      @socket.on 'roomSummary', (roomSummary) =>
#        console.log roomSummary

      @onReady () =>
        @setup()

    onReady: (callback) ->
      @callbacks.push callback

    setup: () ->
      console.log 'Connected'

    onUpdate: (key, callback) ->
      if !@updateCallbacks[key]?
        @updateCallbacks[key] = []
      @updateCallbacks[key].push callback

    rebindUpdateCallbacks: () ->
      for key, callbacks of @updateCallbacks
        for callback in callbacks
          @room.onUpdate key, callback

  module.exports = Client