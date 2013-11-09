define (require, exports, module) ->
  mongoose = require('mongoose')
  mongoose.connect('mongodb://localhost/elderscrolls')
  db = mongoose.connection

  roomSettingsSchema = new mongoose.Schema({
    id: Number,
    name: String,
    difficulty: Number,
    maxUsers: Number,
    password: String,
    roundTime: Number,
    highScores: [{
      id: Number,
      score: Number
    }]
  })

  exports.RoomSettingsModel = mongoose.model 'RoomSettings', roomSettingsSchema

  callback = () ->
  exports.onReady = (mcallback) ->
    callback = mcallback

  db.on('error', console.error.bind(console, 'connection error:'))
  db.once 'open', () ->
    console.log "Database ready"
    callback()

  return