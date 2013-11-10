  _ = require 'underscore'
  fs = require('fs')
  PNGReader = require('png.js');

define (require, exports, module) ->
  ###
  Calculates the tanimoto coefficient between two bitmaps, a ratio of their relative similarity
  Tc=Pab/(Pa+Pb-Pab)
  Compares every third pixel horizontally and vertically for optimization purposes
  imgA and imgB must be buffers!
  ###
  exports.tanimoto_coefficient = (imgA, imgB) ->
    Pa = [] #set of all points in shape a
    Pb = [] #set of all points in shape b

    #fs.readFile('./public/img/out.png', (err, buffer) ->
    reader = new PNGReader(imgA);
    reader.parse( (err, png) ->
      if (err)
        throw err
      for y in [0..png.getHeight()-1] by 3 #skip ev
        for x in [0..png.getWidth()-1] by 3
          if png.getPixel(x,y)[0] == 0

            Pa.push([x,y])
      PaCount = Pa.length

      #img = req.body.img.replace(/^data:image\/png;base64,/,"")
      #img = new Buffer(img, 'base64')#.toString('binary')

      reader = new PNGReader(imgB);
      reader.parse( (err, png) ->
        if (err)
          throw err
        for y in [0..png.getHeight()-1] by 3
          for x in [0..png.getWidth()-1] by 3
            if png.getPixel(x,y)[0] == 0
              Pb.push([x,y])
        PbCount = Pb.length

        intersection = 0
        for pntA in Pa
          for pntB in Pb
            if pntA[0] == pntB[0] && pntA[1] == pntB[1] #compare pixels 1:1
              intersection+=1
        ratio = Math.pow(intersection/(PaCount+PbCount-intersection),.5) #calculate Tanimoto coefficient
        return parseFloat(ratio*100).toFixed(2)+"%");
    )

###
Returns an array of target pixels for chaching purposes
img must be a buffer
skip is the number of pixels skipped in x and y for optimization purposes (3 is optimal)
###
identfyPoints = (img,skip) ->
  points = []
  reader = new PNGReader(img);
  reader.parse( (err, png) ->
    if (err)
      throw err
    for y in [0..png.getHeight()-1] by skip #skip ev
      for x in [0..png.getWidth()-1] by skip
        if png.getPixel(x,y)[0] == 0
          points.push([x,y])
    return points
  )


  ###
  determines the hausdorff distance (max distance between two points that lie on two shapes.
  Da,Db=min(abs(a-b)) where a is an element of Pa and b is an element of Pb
  Hd(a,b)=max(max(Da),max(Db))
  imgA and imgB must be buffers
  ###
  exports.hausdorff_distances = (imgA, imgB) ->
    Da = [] #set of all distances from shape a to shape b
    Pa = [] #set of all points in shape a
    Pb = [] #set of all points in shape b

    #fs.readFile('./public/img/Square1.png', (err, buffer) ->

    reader = new PNGReader(imgA);
    reader.parse( (err, png) ->
      if (err)
        throw err
      for y in [0..png.getHeight()-1]
        for x in [0..png.getWidth()-1]
          if png.getPixel(x,y)[0] == 0
            Pa.push([x,y])

      #fs.readFile('./public/img/Square2.png', (err, buffer) ->
      reader = new PNGReader(imgB);
      reader.parse( (err, png) ->
        if (err)
          throw err
        for y in [0..png.getHeight()-1]
          for x in [0..png.getWidth()-1]
            if png.getPixel(x,y)[0] == 0
              Pb.push([x,y])

        distance = []
        for ptA in Pa
          for ptB in Pb
            distanceMins = []
            distanceMins.push(Math.pow((ptA[0]-ptB[0]),2)+Math.pow((ptA[1]-ptB[1]),2))
            distance.push _.min(distanceMins)
        return _.max(distance)
      )
    );
