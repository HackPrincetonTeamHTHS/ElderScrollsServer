ImportPictures = require './libraries/ImportPictures'

module.exports = (req, res) ->
    if req.query['run'] == 'yes'
        ImportPictures.importAll()
        res.send 'Import complete'
    else
      res.send '<a href="?run=yes">Run Import</a>'