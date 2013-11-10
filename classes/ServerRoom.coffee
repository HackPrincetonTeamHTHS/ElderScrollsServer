Room = require './Room'
d = require './Database'
_ = require 'underscore'

class ServerRoom extends Room
  constructor: (settings, callback) ->
    super null, settings
    @run()
    setTimeout () -> # TODO: figure out why this delay is necessary
      callback()
    , 1000

  getRandomImage: (callback) ->
    d.BaseImagesModel.find {difficulty: @getSetting('difficulty')}, (err, images) ->
      callback _.sample(images)

  run: () ->
    @getRandomImage (image) =>
      @set 'currentImage', image
      @set 'running', true
      runTime = @getSetting 'runTime'
      setTimeout () =>
        @finish()
      , (runTime + 5500)
  #      console.log 'Room', @id, 'now running for', runTime, 'milliseconds'

  finish: () ->
    @set 'roundStats', @getRoundStats()
    @set 'running', false
    finishTime = @getSetting 'finishTime'
    setTimeout () =>
      @run()
    , (finishTime + 500)
#      console.log 'Room', @id, 'now finishing for', finishTime, 'milliseconds'

  getRoundStats: () ->
    roundStats = []
    for user in @users
      roundStats.push {name: user.get('name'), drawingScore: user.get('drawingScore'), drawingData: user.get('drawingData')}
    return roundStats

module.exports = ServerRoom