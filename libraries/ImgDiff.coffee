_ = require 'underscore'

exports.distances = (req, res) ->
  fs = require('fs')
  PNG = require('pngjs').PNG;

  width = 0 #global width of image
  height = 0 #global height of image
  Pa = [] #set of all points in shape a
  Pb = [] #set of all points in shape b
  Da = [] #set of all distances from shape a to shape b

  fs.createReadStream('./public/img/Square1.png')
  .pipe(new PNG(
      filterType: 4
    ))
  .on('parsed', () ->
      console.log(this.height)
      for y in [0..this.height]
        for x in [0..this.width]
          idx = (this.width * y + x) << 2;
          if this.data[idx] ==0
            Pa.push([x,y])

      fs.createReadStream('./public/img/Square2.png').pipe(new PNG({filterType:4})).on('parsed', () ->
        for y in [0..this.height]
          for x in [0..this.width]
            idx = (this.width * y + x) << 2;
            if this.data[idx] ==0
              Pb.push([x,y])

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




  ###
        # invert color
        this.data[idx] = 255 - this.data[idx];
        this.data[idx+1] = 255 - this.data[idx+1];
        this.data[idx+2] = 255 - this.data[idx+2];

        # and reduce opacity
        this.data[idx+3] = this.data[idx+3] >> 1;

    #this.pack().pipe(fs.createWriteStream('out.png'));
  ###
