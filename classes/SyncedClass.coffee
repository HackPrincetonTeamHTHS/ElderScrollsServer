define (require, exports, module) ->
  class SyncedClass
    constructor: (@objectId, @socket, @room = null) ->
      @data = {}
      @callbacks = {}
      @sockets = []
      @socket.on 'sync', (data) ->
        if data['objectId'] == @objectId
          @set data['key'], data['value'], false

    set: (key, value, sync = true) ->
      @data[key] = value
      if @callbacks[key]?
        for callback in @callbacks[key]
          callback value
      if @callbacks['*']?
        for callback in @callbacks['*']
          callback value
      if sync
        data =
          objectId: @objectId
          key: key
          value: value
        if @room?
          @socket.broadcast.to(@room).emit 'sync', data
        else
          @socket.emit 'sync', data

    get: (key) ->
      return @data[key]

    onUpdate: (key, callback) ->
      if !@callbacks[key]
        @callbacks[key] = []

      @callbacks[key].push(callback)



  module.exports = SyncedClass