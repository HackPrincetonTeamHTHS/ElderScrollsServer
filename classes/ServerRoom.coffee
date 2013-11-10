define (require, exports, module) ->
  Room = require './Room'
  io = require('socket.io-client')
  database = require './Database'

  class ServerRoom extends Room
    constructor: (settings, callback) ->
      socket = io.connect 'localhost', {port: 3000} #TODO: load port dynamically from server config
      socket.on 'connect', () =>
        super socket, settings
        console.log "ServerRoom", @id, "connected to local socket"
        @run()
        callback()

    run: () ->
      @set 'running', true
      runTime = @get('settings')['runTime']
      setTimeout () =>
        @finish()
      , runTime
#      console.log 'Room', @id, 'now running for', runTime, 'milliseconds'

    finish: () ->
      @set 'running', false
      finishTime = @get('settings')['finishTime']
      setTimeout () =>
        @run()
      , finishTime
#      console.log 'Room', @id, 'now finishing for', finishTime, 'milliseconds'

  return ServerRoom