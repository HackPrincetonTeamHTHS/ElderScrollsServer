define (require, exports, module) ->
  Room = require './Room'
  User = require './User'
  _ = require 'underscore'

  class Server
    constructor: (@io) ->
      @rooms = {}
      @currentUsers = []
      @currentUserId = 0

      @io.on 'connection', (socket) =>
        @prepareUser socket

    addRoom: () ->
      newRoom = new Room
      newRoom.onUpdate 'running', (val) ->
        console.log val
      @rooms.push newRoom
      return newRoom

    prepareUser: (socket) ->
      newId = @currentUserId
      @currentUserId += 1

      newUser = new User(socket, newId)
      @addUser socket, newUser
      socket.emit 'newUser', {id: newId}

    addUser: (socket, user) ->
      @currentUsers[user['id']] = user

      socket.on 'changeRoom', (data) =>
        @onUserChangeRoom user, data['fromId'], data['toId']

      socket.on 'disconnect', () =>
        console.log "User #", user['id'], "disconnected"
        @removeUser user

    removeUser: (user) ->
      @currentUsers = _.reject @currentUsers, (el) ->
        return el.id == user.id

    getRoomById: (id) ->
      return _.find @rooms, (room) ->
        room['id'] == id

    onUserChangeRoom: (user, fromId, toId) ->
      @getRoomById(fromId).removeUser(user)
      @getRoomById(toId).addUser(user)

  module.exports = Server