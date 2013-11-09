define (require, exports, module) ->
  User = require './User'
  class Client
    constructor: () ->
      @socket = io.connect ''
      @socket.on 'newUser', (data) =>
        @me = new User(@socket, data['id'], 'Name')
        @onReady()

    onReady: () ->
      alert 'Connected'
      @me.changeRoom(3)

  module.exports = Client