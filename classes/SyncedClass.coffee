define (require, exports, module) ->
  class SyncedClass
    constructor: (@objectId, @socket, @room = null) ->
      @data = {}
      @callbacks = {}
      @socket.on 'sync', (data) =>
        if data['objectId'] == @objectId
          console.log 'Receiving sync', data['key'], '=', data['value']
          @set data['key'], data['value'], false

    set: (key, value, sync = true) ->
      console.log "Setting", key, "=>", value
      @data[key] = value
      if @callbacks[key]?
        for callback in @callbacks[key]
          callback value
      if @callbacks['*']?
        for callback in @callbacks['*']
          callback value
      if sync
        console.log 'Sending sync', key, '=', value
        data =
          objectId: @objectId
          key: key
          value: value
        if @room?
          @socket.emit 'broadcast', {room: @room, event: 'sync', data: data}
        else
          @socket.emit 'sync', data

    get: (key) ->
      return @data[key]

    onUpdate: (key, callback) ->
      if !@callbacks[key]?
        @callbacks[key] = []

      @callbacks[key].push(callback)

  module.exports = SyncedClass