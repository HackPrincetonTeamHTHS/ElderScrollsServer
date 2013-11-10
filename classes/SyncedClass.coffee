if typeof define != 'function'
  define = require('amdefine')(module)

define (require, exports, module) ->
  _ = require 'underscore'

  class SyncedClass
    constructor: (@objectId, socket, @room = null) ->
      @data = {}
      @callbacks = {}
      @sockets = []

      if socket?
        @addSocket socket

    addSocket: (socket) ->
      @sockets.push socket
      socket.on 'sync', (data) =>
        if data['objectId'] == @objectId
          console.log @objectId, 'receiving sync', data['key'], '=', data['value']
          @set data['key'], data['value'], false

    removeSocket: (socket) ->
      @sockets = _.filter @sockets, (s) ->
        console.log socket # TODO: SyncedClass::removeSocket()

    set: (key, value, sync = true) ->
#      console.log "Setting", key, "=>", value
      @data[key] = value
      if @callbacks[key]?
        for callback in @callbacks[key]
          callback value
      if @callbacks['*']?
        for callback in @callbacks['*']
          callback value
      if sync
        if key != 'running'
          console.log @objectId, 'sending sync', key, '=', value
        data =
          objectId: @objectId
          key: key
          value: value
        for socket in @sockets
          socket.emit 'sync', data

    get: (key) ->
      return @data[key]

    onUpdate: (key, callback) ->
      if !@callbacks[key]?
        @callbacks[key] = []

      @callbacks[key].push(callback)

  module.exports = SyncedClass