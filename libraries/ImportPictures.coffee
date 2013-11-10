ImgDiff = require "./ImgDiff"
fs = require('fs')
d = require '../classes/Database'
path = require 'path'
async = require 'async'
_ = require 'underscore'

sources =
  './public/img/easy': 1
  './public/img/medium': 2
  './public/img/hard': 3

exports.importAll = (masterCallback) ->
  successfulCount = 0
  totalCount = 0
  async.eachSeries _.keys(sources), (folder, callback) ->
    fs.readdir folder, (err, files) ->
      if err
        throw err;
      async.eachSeries files, (file, callback2) ->
        console.log folder, file
        fs.readFile path.join(folder, file), (err, buffer) ->
          if err
            throw err
          image = new d.BaseImagesModel()
          image.difficulty = sources[folder]
          image.image = buffer.toString('binary')
          image.target_points = ImgDiff.identifyPoints(buffer, 3)
          image.save (err) ->
            if err
              throw err
            else
              successfulCount++
            totalCount++
          callback2()
      , () ->
        callback()
  , () ->
    console.log "ImportPictures: Imported", successfulCount, "of", totalCount, "images successfuly"
    masterCallback()