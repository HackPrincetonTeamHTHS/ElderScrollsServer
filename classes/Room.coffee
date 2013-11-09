define (require, exports, module) ->
  database = require './Database'
  SyncedClass = require './SyncedClass'

  class Room extends SyncedClass
    constructor: (@id) ->
      @refresh()

    refresh: () ->
      database.RoomSettingsModel.find {id: @id}, (err, data) ->
        if err
          console.log err
        console.log data

  module.exports = Room