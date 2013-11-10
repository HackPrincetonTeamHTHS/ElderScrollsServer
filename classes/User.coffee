if !window?
  `var define = require('amdefine')(module)`
else
  define = window.define

define (require, exports, module) ->
  SyncedClass = require './SyncedClass'

  class User extends SyncedClass
    constructor: (@socket, @id, @name) ->
      super 'User', socket
      @set 'currentRoom', -1, false

    changeRoom: (id) ->
      console.log "Changing room from", @get('currentRoom'), "to", id
      @set 'previousRoom', @get('currentRoom')
      @set 'currentRoom', id

    getSocket: () ->
      return @socket

    updateDrawing: (data) ->
      @set 'drawingData', data

    getScore: () ->
      return @get('drawingScore')

  module.exports = User