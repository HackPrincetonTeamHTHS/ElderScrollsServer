d = require('./classes/Database')

createRooms = () ->
  room = new d.RoomSettingsModel()

  room.name = "Easy Peasy"
  room.difficulty = 1
  room.previewTime = 3
  room.runTime = 20
  room.finishTime = 5
  room.save (err) ->
    if err
      throw err

  room.name = "Ink my Dink"
  room.difficulty = 2
  room.previewTime = 5
  room.runTime = 20
  room.finishTime = 10
  room.save (err) ->
    if err
      throw err

  room.name = "Not an Inkling"
  room.difficulty = 3
  room.previewTime = 5
  room.runTime = 25
  room.finishTime = 10
  room.save (err) ->
    if err
      throw err

importAllRooms = () ->
  room = new d.RoomSettingsModel()
  room.find({}, (err, obj) ->
    if err
      throw err
    return obj)