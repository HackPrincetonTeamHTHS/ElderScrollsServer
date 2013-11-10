Room = require './Room'
io = require('socket.io-client')
database = require './Database'

class ServerRoom extends Room
  constructor: (settings, callback) ->
    super null, settings
    @run()
    setTimeout () -> # TODO: figure out why this delay is necessary
      callback()
    , 1000

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

module.exports = ServerRoom