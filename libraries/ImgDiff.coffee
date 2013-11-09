_ = require 'underscore'
fs = require('fs')
PNG = require('pngjs').PNG;

exports.tanimoto_coefficient = (req, res) ->
  console.log(req.body.img)
  Pa = [] #set of all points in shape a
  Pb = [] #set of all points in shape b

  fs.createReadStream("./public/img/out.png")
  .pipe(new PNG(
    filterType: 4
  ))
  .on('parsed', () ->
    for y in [0..this.height]
      for x in [0..this.width]
        idx = (this.width * y + x) << 2; #get pixel indexes
        if this.data[idx] ==0
          Pa.push([x,y])
    PaCount = Pa.length
    console.log PaCount

    img = req.body.img.replace(/^data:image\/png;base64,/,"")
    ###
      fs.writeFile("out.png",img, 'base64', (err) ->
        console.log(err);
      )
    ###
    img = new Buffer(img, 'base64').toString('binary')
    console.log img

    Stream = require('stream')
    imgstream = new Stream()
    #imgstream.readable = true

    imgstream.pipe = (dest) ->
      dest.write(img)

    imgstream
    .pipe(new PNG(
      filterType: 4
    ))
    .on('parsed', () ->
      for y in [0..this.height]
        for x in [0..this.width]
          idx = (this.width * y + x) << 2;
          if this.data[idx] ==0
            Pb.push([x,y])
      PbCount = Pb.length
      console.log PbCount

      intersection = 0
      for pntA in Pa
        for pntB in Pb
          if pntA[0] == pntB[0] && pntA[1] == pntB[1] #compare pixels 1:1
            intersection+=1
      ratio = Math.pow(intersection/(PaCount+PbCount-intersection),.1) #calculate Tanimoto coefficient
      console.log(ratio)
      res.send(parseFloat(ratio*100).toFixed(2)+"%");
    );
  )


exports.hausdorff_distances = (req, res) ->
  Da = [] #set of all distances from shape a to shape b
  Pa = [] #set of all points in shape a
  Pb = [] #set of all points in shape b
  fs.createReadStream('./public/img/Square1.png')
  .pipe(new PNG(
      filterType: 4
    ))
  .on('parsed', () ->
      for y in [0..this.height]
        for x in [0..this.width]
          idx = (this.width * y + x) << 2;
          if this.data[idx] ==0
            Pa.push([x,y]) #array of pixels in drawing A

      fs.createReadStream('./public/img/Square2.png').pipe(new PNG({filterType:4})).on('parsed', () ->
        for y in [0..this.height]
          for x in [0..this.width]
            idx = (this.width * y + x) << 2;
            if this.data[idx] ==0
              Pb.push([x,y]) #array of pixels in drawing B

        distance = []
        for ptA in Pa
          for ptB in Pb
            distanceMins = []
            distanceMins.push(Math.pow((ptA[0]-ptB[0]),2)+Math.pow((ptA[1]-ptB[1]),2))
            distance.push _.min(distanceMins)
        console.log _.max(distance)
        res.send("done")
      );

    )
