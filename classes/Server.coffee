ServerRoom = require './ServerRoom'
User = require './User'
_ = require 'underscore'
Lobby = require './Lobby'
database = require './Database'
ImgDiff = require '../libraries/ImgDiff'

class Server
  constructor: (@io) ->
    @rooms = []
    @currentUsers = []
    @currentUserId = 0

    @roomSummary = []

    @addRoom {id: 42, name: "Test Room", runTime: 1000, finishTime: 1000, difficulty: 2}
    @addRoom {id: 11, name: "Test Room", runTime: 5000, finishTime: 1000, difficulty: 1}
    @addRoom {id: 15, name: "Test Room", runTime: 3000, finishTime: 1000, difficulty: 3}

    database.RoomSettingsModel.find (err, rooms) ->
      for room in rooms
        @addRoom room

    @loadLobby () =>
      @io.on 'connection', (socket) =>
        @prepareUser socket

    setInterval () =>
      @updateRoomSummary()
    , 500

  loadLobby: (callback) ->
    lobbyRoom = new Lobby () =>
      @rooms.push lobbyRoom
      console.log "Lobby initialized"
      callback()

  addRoom: (settings) ->
    newRoom = new ServerRoom settings, () =>
      @rooms.push newRoom
      console.log 'Added new room with id', settings['id']

  prepareUser: (socket) ->
    newId = @currentUserId
    @currentUserId += 1
    newUser = new User(socket, newId)
    @addUser socket, newUser
    socket.emit 'newUser', {id: newId}

  addUser: (socket, user) ->
    @currentUsers.push user
    @attachListeners socket, user
#    @getRoomById(-1).addUser(user)
    console.log "User #", user['id'], "connected"

  attachListeners: (socket, user) ->
    socket.on 'broadcast', (data) ->
      socket.broadcast.to(data['room']).emit(data['event'], data['data'])

    socket.on 'disconnect', () =>
      console.log "User #", user['id'], "disconnected"
      @removeUser user

    user.onUpdate 'currentRoom', (toId) =>
      @onUserChangeRoom user, user.get('previousRoom'), toId

    user.onUpdate 'drawingData', (data) =>
      console.log "Drawing Data"

      currentRoom = @getRoomById(user.get 'currentRoom')
      if currentRoom['id'] == -1
        return

      # score the drawing data
      # TODO: fix buffers
#      matchImage = currentRoom.get 'currentImage'
#      data.replace(/^data:image\/png;base64,/,"")
#      matchImageBuffer = new Buffer(matchImage['image'])
#      drawingBuffer = new Buffer(data, 'base64')
#      score = ImgDiff.tanimoto_coefficient matchImageBuffer, drawingBuffer

      score = Math.random() * 100
      setTimeout () ->
        user.set 'drawingScore', score
      , 100

  removeUser: (user) ->
    @currentUsers = _.reject @currentUsers, (el) ->
      return el.id == user.id

  getRoomById: (id) ->
    room = _.find @rooms, (elem) ->
      elem['id'] == id
    # TODO: check if room is valid and exists
    return room

  onUserChangeRoom: (user, fromId, toId) ->
    @getRoomById(fromId).removeUser(user)
    @getRoomById(toId).addUser(user)

  updateRoomSummary: () ->
    @roomSummary = []

    for room in @rooms
      settings = room.get 'settings'
      summary =
        name: settings['name']
        playerCount: room['users'].length
        runTime: settings['runTime']
        difficulty: settings['difficulty']
      @roomSummary.push summary

    for user in @currentUsers
      user.socket.emit 'roomSummary', @roomSummary

module.exports = Server