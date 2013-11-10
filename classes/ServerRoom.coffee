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
    @roundStats = []

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
      , (runTime + 5000)
  #      console.log 'Room', @id, 'now running for', runTime, 'milliseconds'

  finish: () ->
    @set 'roundStats', @roundStats
    @set 'running', false
    finishTime = @getSetting 'finishTime'
    setTimeout () =>
      @run()
    , finishTime
#      console.log 'Room', @id, 'now finishing for', finishTime, 'milliseconds'

module.exports = ServerRoom