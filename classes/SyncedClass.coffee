define (require, exports, module) ->
  class SyncedClass
    constructor: (@className, @socket) ->
      @data = {}
      @callbacks = {}
      @socket.on 'sync', (data) ->
        if data['className'] == @className
          @set data['key'], data['value'], false

    set: (key, value, sync = true) ->
      @data[key] = value
      if @callbacks[key]
        for callback in @callbacks[key]
          callback value
      if sync
        data =
          className: @className
          key: key
          value: value
        @socket.emit 'sync', data

    get: (key) ->
      return @data[key]

    onSet: (key, callback) ->
      if !@callbacks[key]
        @callbacks[key] = []

      @callbacks[key].push(callback)

  module.exports = SyncedClass