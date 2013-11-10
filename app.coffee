###
Module dependencies.
###

port = process.env.PORT || 3000

require 'coffee-script'
express = require('express')
http = require('http')
path = require('path')

app = express();

app.configure(() ->
  app.set('port', port);
  app.use(express.favicon());
  app.use(express.logger('dev'));
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use('/classes', express.static(path.join(__dirname, 'classes')));
  app.use(require('less-middleware')({ src: __dirname + '/client' }));
  app.use(express.static(path.join(__dirname, 'client')));
)

app.configure 'development', () ->
  app.use express.errorHandler()

app.configure 'production', () ->
  process.on 'uncaughtException', (err) ->
    # handle the error safely
    console.log(err)

#app.get('/hdistances',ImgDiff.hausdorff_distances)
#app.post('/tcoeff',ImgDiff.tanimoto_coefficient)

server = http.createServer(app)
io = require('socket.io').listen(server)
io.set('log level', 1)

server.listen(app.get('port'), () ->
  console.log("Express server listening on port " + app.get('port'))
)

console.log "Initializing database connection"

database = require './classes/Database'

database.onReady () ->
  console.log "Ready"
  console.log "Starting up real time server"

  Server = require './classes/Server'
  s = new Server(io)

  importRoute = require './import'
  app.get '/import', importRoute
