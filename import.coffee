ImportPictures = require './libraries/ImportPictures'
d = require './classes/Database'

module.exports = (req, res) ->
    if req.query['run'] == 'yes'
      d.empty () ->
        ImportPictures.importAll () ->
          res.send 'Import complete'
    else
      res.send '<a href="?run=yes">Run Import</a>'