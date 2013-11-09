if process.env.MONGO_URL?
  url = process.env.MONGO_URL
else
  url = 'mongodb://localhost/elderscrolls'

define (require, exports, module) ->
  mongoose = require('mongoose')
  mongoose.connect(url)
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