define (require, exports, module) ->
  ServerRoom = require './ServerRoom'
  User = require './User'
  _ = require 'underscore'

  class Server
    constructor: (@io) ->
      @rooms = []
      @currentUsers = []
      @currentUserId = 0

      @addRoom 3

      @io.on 'connection', (socket) =>
        socket.on 'broadcast', (data) ->
          socket.broadcast.to(data['room']).emit(data['event'], data['data'])
        @prepareUser socket

    addRoom: (id) ->
      newRoom = new ServerRoom {id: id, runTime: 1000, finishTime: 500}, () =>
        newRoom.onUpdate 'running', (val) =>
          console.log val
        @rooms.push newRoom
        console.log 'Added new room with id', id

    prepareUser: (socket) ->
      newId = @currentUserId
      @currentUserId += 1

      newUser = new User(socket, newId)
      @addUser socket, newUser
      socket.emit 'newUser', {id: newId}

    addUser: (socket, user) ->
      @currentUsers.push user

      console.log "User #", user['id'], "connected"

      user.onUpdate 'currentRoom', (toId) =>
        @onUserChangeRoom user, user['previousRoom'], toId

      user.onUpdate 'drawingData', (data) ->
        # score the drawing data
        user.set 'drawingScore', Math.random()

      socket.on 'disconnect', () =>
        console.log "User #", user['id'], "disconnected"
        @removeUser user

    removeUser: (user) ->
      @currentUsers = _.reject @currentUsers, (el) ->
        return el.id == user.id

    getRoomById: (id) ->
      if id == -1
        return null
      return _.find @rooms, (room) ->
        room['id'] == id

    onUserChangeRoom: (user, fromId, toId) ->
#      @getRoomById(fromId).removeUser(user)
      @getRoomById(toId).addUser(user)

  module.exports = Server