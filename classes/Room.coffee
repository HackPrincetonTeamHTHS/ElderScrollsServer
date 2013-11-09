define (require, exports, module) ->
  SyncedClass = require './SyncedClass'
  _ = require 'underscore'

  class Room extends SyncedClass
    constructor: (socket, settings) ->
      super 'Room', socket

      @running = false
      @users = []

      @loadSettings settings

      @run()

    loadSettings: (settings) ->
      for key, val in settings
        @set key, val

    run: () ->
      @set 'running', true
      runTime = @get 'runTime'
      setTimeout @finish, runTime

    finish: () ->
      @set 'running', false
      finishTime = @get 'finishTime'
      setTimeout @run, finishTime

    getSocketRoomName: () ->
      return 'room' + @id

    addUser: (user) ->
      @users.push(user)
      user.getSocket().join @getSocketRoomName()

    removeUser: (user) ->
      @users = _.filter @users, (elem) ->
        return user['id'] == elem['id']
      user.getSocket.leave @getSocketRoomName()

  module.exports = Room