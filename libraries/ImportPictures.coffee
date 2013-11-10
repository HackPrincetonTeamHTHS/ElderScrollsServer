ImgDiff = require "./ImgDiff"
fs = require('fs')

importAll = () ->
  for folder in ['./public/img/easy','./public/img/medium','./public/img/hard']
    fs.readdir(folder, (err,files) ->
      if(err)
        throw err;
      files.forEach( (file) ->
        fs.readFile(file, (err, buffer) ->

          BaseImages = mongoose.model('BaseImages', BaseImagesSchema);

          image = new BaseImages()
          image.difficulty = 1
          image.image = buffer.toString('binary')
          image.target_points = ImgDiff.identifyPoints(buffer,3)
          image.save( (err) ->
            console.log err
          )
        )
      )
    )