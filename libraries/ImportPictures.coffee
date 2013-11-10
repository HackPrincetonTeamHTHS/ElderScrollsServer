ImgDiff = require "./ImgDiff"
fs = require('fs')
d = require '../classes/Database'
path = require 'path'
async = require 'async'

exports.importAll = () ->
  async.each ['./public/img/easy','./public/img/medium','./public/img/hard'], (folder, callback) ->
    fs.readdir folder, (err, files) ->
      if err
        throw err;
      async.each files, (file, callback2) ->
        fs.readFile path.join(folder, file), (err, buffer) ->
          if err
            throw err
          image = new d.BaseImagesModel()
          image.difficulty = 1
          image.image = buffer.toString('binary')
          image.target_points = ImgDiff.identifyPoints(buffer, 3)
          image.save (err) ->
            console.log err
          callback2()
      , () ->
        callback()