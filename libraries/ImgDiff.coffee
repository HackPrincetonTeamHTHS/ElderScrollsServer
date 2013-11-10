_ = require 'underscore'
fs = require('fs')
PNGReader = require('png.js');

###
Calculates the tanimoto coefficient between two bitmaps, a ratio of their relative similarity
Tc=Pab/(Pa+Pb-Pab)
Compares every third pixel horizontally and vertically for optimization purposes
imgA and imgB must be buffers!
###
exports.tanimoto_coefficient = (imgA, imgB, callback) ->
  Pa = [] #set of all points in shape a
  Pb = [] #set of all points in shape b
  ratio = 0

  #fs.readFile('./public/img/out.png', (err, buffer) ->
  PaCount = 0
  reader = new PNGReader(imgA);
  reader.parse( (err, png) ->
    if (err)
      throw err
    #console.log(png)
    for y in [0..png.getHeight()-1] by 3 #skip ev
      for x in [0..png.getWidth()-1] by 3
        if png.getPixel(x,y)[0] == 0
          Pa.push([x,y])
    PaCount = Pa.length
    console.log "pacount", PaCount

    #img = req.body.img.replace(/^data:image\/png;base64,/,"")
    #img = new Buffer(img, 'base64')#.toString('binary')

    PbCount = 0;
    reader = new PNGReader(imgB);
    reader.parse( (err, png) ->
      if (err)
        throw err
      #console.log png
      for y in [0..png.getHeight()-1] by 3
        for x in [0..png.getWidth()-1] by 3
          if png.getPixel(x,y)[0] == 0
            Pb.push([x,y])
      PbCount = Pb.length
      console.log "Pb", PbCount

      intersection = 0
      for pntA in Pa
        for pntB in Pb
          if pntA[0] == pntB[0] && pntA[1] == pntB[1] #compare pixels 1:1
            intersection+=1
      ratio = Math.pow(intersection/(PaCount+PbCount-intersection),.5) #calculate Tanimoto coefficient
      callback(parseFloat(ratio*100).toFixed(2)+"%"));
  )

exports.test = (req,res) ->
  Pa = [] #set of all points in shape a
  Pb = [] #set of all points in shape b
  ratio = 0
  draw = new Buffer("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",'base64')
  #fs.readFile('./public/img/out.png', (err, buffer) ->
  PaCount = 0
  reader = new PNGReader(draw);
  reader.parse( (err, png) ->
    if (err)
      throw err
    #console.log(png)
    for y in [0..png.getHeight()-1] by 3 #skip ev
      for x in [0..png.getWidth()-1] by 3
        if png.getPixel(x,y)[0] == 0
          Pa.push([x,y])
    PaCount = Pa.length
    console.log "pacount", PaCount

    #img = req.body.img.replace(/^data:image\/png;base64,/,"")
    #img = new Buffer(img, 'base64')#.toString('binary')
    fs.readFile('./public/img/hard/Untitled 14.png', (err, buffer) ->
      PbCount = 0;
      reader = new PNGReader(buffer);
      reader.parse( (err, png) ->
        if (err)
          throw err
        #console.log png
        for y in [0..png.getHeight()-1] by 3
          for x in [0..png.getWidth()-1] by 3
            if png.getPixel(x,y)[0] == 0
              Pb.push([x,y])
        PbCount = Pb.length
        console.log "Pb", PbCount

        intersection = 0
        for pntA in Pa
          for pntB in Pb
            if pntA[0] == pntB[0] && pntA[1] == pntB[1] #compare pixels 1:1
              intersection+=1
        ratio = Math.pow(intersection/(PaCount+PbCount-intersection),.5) #calculate Tanimoto coefficient
        res.send (parseFloat(ratio*100).toFixed(2)+"%"));
    )
  )


###
Returns an array of target pixels for chaching purposes
img must be a buffer
skip is the number of pixels skipped in x and y for optimization purposes (3 is optimal)
###
exports.identifyPoints = (img,skip) ->
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
