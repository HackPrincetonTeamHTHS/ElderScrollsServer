define (require, exports, module) ->
  SyncedClass = require './SyncedClass'
  _ = require 'underscore'

  class Room extends SyncedClass
    constructor: (socket, settings) ->
      super 'Room', socket

      @running = false
      @users = []

      @loadSettings settings

      @room = @getSocketRoomName()

    loadSettings: (settings) ->
      @id = settings['id']
      @set 'settings', settings

    getSocketRoomName: () ->
      return 'room' + @id

    addUser: (user) ->
      @users.push(user)
      user.getSocket().join @getSocketRoomName()
      user.getSocket().emit 'newRoom', {settings: @get 'settings'}

    removeUser: (user) ->
      @users = _.filter @users, (elem) ->
        return user['id'] == elem['id']
      user.getSocket.leave @getSocketRoomName()

  module.exports = Room