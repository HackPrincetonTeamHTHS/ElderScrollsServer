define (require, exports, module) ->
  Room = require './Room'
  User = require './User'

  class Server
    constructor: (@io) ->
      @rooms = {}
      @currentUsers = {}
      @currentUserId = 0

      @io.on 'connection', (socket) =>
        @prepareUser socket

    addRoom: () ->
      newRoom = new Room
      @rooms.push newRoom
      return newRoom

    prepareUser: (socket) ->
      newId = @currentUserId
      @currentUserId += 1

      newUser = new User(socket, newId)
      @addUser socket, newUser
      socket.emit 'newUser', {id: newId}

    addUser: (socket, user) ->
      newUser = new User(socket)
      @currentUsers[user['id']] = newUser
      socket.on 'changeRoom', (data) =>
        @onUserChangeRoom newUser, data['fromId'], data['toId']
      socket.on 'disconnect', () =>
        console.log "User #", user['id'], "disconnected"
        @removeUser user['id']

    removeUser: (id) ->
      if @currentUsers[id]?
        delete @currentUsers[id]

    onUserChangeRoom: (id, fromId, toId) ->
      @rooms[fromId].removeUser(id)
      @rooms[toId].addUser(id)

  module.exports = Server