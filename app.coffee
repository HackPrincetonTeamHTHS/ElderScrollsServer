###
Module dependencies.
###

port = process.env.PORT || 3000

require 'coffee-script'
express = require('express')
http = require('http')
path = require('path')

requirejs = require 'requirejs'
requirejs.config { nodeRequire: require }
ImgDiff = require('./libraries/ImgDiff')

app = express();

app.configure(() ->
  app.set('port', port);
  app.use(express.favicon());
  app.use(express.logger('dev'));
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use('/classes', express.static(path.join(__dirname, 'classes')));
  app.use(express.static(path.join(__dirname, 'client')));
)

app.configure('development', () ->
  app.use(express.errorHandler());
)

#app.get('/hdistances',ImgDiff.hausdorff_distances)
#app.post('/tcoeff',ImgDiff.tanimoto_coefficient)

server = http.createServer(app)
io = require('socket.io').listen(server)
io.set('log level', 1)

server.listen(app.get('port'), () ->
  console.log("Express server listening on port " + app.get('port'))
)

process.on 'uncaughtException', (err) ->
  # handle the error safely
  console.log(err)

console.log "Initializing database connection"
requirejs ['./classes/Database'], (database) ->
  database.onReady () ->
    console.log "Ready"
    console.log "Starting up real time server"

    requirejs ['./classes/Server'], (Server) ->
      s = new Server(io)
