define (require, exports, module) ->
  SyncedClass = require './SyncedClass'

  class User extends SyncedClass
    constructor: (@socket, @id, @name) ->
      super 'User', socket
      @set 'currentRoom', -1, false

    changeRoom: (id) ->
      @socket.emit 'changeRoom', {fromId: @get 'currentRoom', toId: id}

  module.exports = User