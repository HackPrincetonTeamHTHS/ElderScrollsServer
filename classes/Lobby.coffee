define (require, exports, module) ->
  ServerRoom = require './ServerRoom'

  class Lobby extends ServerRoom
    constructor: (callback) ->
      settings =
        id: -1
        name: "Lobby"
      super settings, callback

    run: () ->

    finish: () ->
