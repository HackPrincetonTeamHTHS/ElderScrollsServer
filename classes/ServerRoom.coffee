define (require, exports, module) ->
  io = require('socket.io-client')
  database = require './Database'

  class ServerRoom extends Room
    constructor: (settings) ->
      socket = io.connect 'localhost', {port: 3000} #TODO: load port dynamically from server config
      socket.join @getSocketRoomName()
      super socket, settings

  return ServerRoom