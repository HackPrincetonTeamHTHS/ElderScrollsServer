if process.env.MONGO_URL?
  url = process.env.MONGO_URL
else
  url = 'mongodb://localhost/elderscrolls'

mongoose = require('mongoose')
mongoose.connect(url)
db = mongoose.connection
async = require 'async'

roomSettingsSchema = new mongoose.Schema({
  #id: Number,
  name: String,
  difficulty: Number, #1:easy, 2:medium,3:difficult
#    maxUsers: Number,
#    password: String,
  previewTime: {type: Number, default: 3}, #amount of time you get to view the image
  runTime: {type: Number, default: 20}, #amount of time to draw
  finishTime: {type: Number, default: 5} #time to sit at finish screen
#    highScores: [{
#      id: Number,
#      score: Number
#    }]
})

baseImagesSchema = new mongoose.Schema({
  difficulty: Number,
  image: String,
  target_points: mongoose.Schema.Types.Mixed
})

exports.RoomSettingsModel = mongoose.model 'RoomSettings', roomSettingsSchema
exports.BaseImagesModel = mongoose.model 'BaseImages', baseImagesSchema

callback = () ->
exports.onReady = (mcallback) ->
  callback = mcallback

db.on('error', console.error.bind(console, 'connection error:'))
db.once 'open', () ->
  console.log "Database ready"
  callback()

exports.empty = (masterCallback) ->
  async.parallel [
    (callback) ->
      exports.RoomSettingsModel.remove {}, () ->
        callback()
    , (callback) ->
      exports.BaseImagesModel.remove {}, () ->
        callback()
  ], () ->
    console.log "Database: Emptied all models"
    masterCallback()