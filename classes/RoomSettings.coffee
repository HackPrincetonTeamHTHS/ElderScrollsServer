mongoose = require('mongoose')
mongoose.connect('mongodb://localhost/elderscrolls')

roomSettingsSchema = new mongoose.Schema({
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

class RoomSettings
  update: () ->
