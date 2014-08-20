###
Module dependencies.
###

port = process.env.PORT || 3000

require 'coffee-script'
express = require('express')
http = require('http')
path = require('path')

app = express();

app.set('port', port);
app.use(express.favicon());
app.use(express.logger('dev'));
app.use(express.bodyParser());
app.use(express.methodOverride());
app.use(app.router);
app.use(require('less-middleware')(path.join(__dirname, 'client')));
app.use(require('connect-coffee-script')({src: path.join(__dirname, 'client'),bare: true}));
app.use('/',express.static(path.join(__dirname, 'client')));
app.use('/classes', express.static(path.join(__dirname, 'classes')));



if ('development' == app.get('env'))
  app.use express.errorHandler()

if ('production' == app.get('env'))
  console.log "Root directory at", __dirname
  process.on 'uncaughtException', (err) ->
    # handle the error safely
    console.log(err)

#ImgDiff = require('./libraries/ImgDiff')
#app.get('/testimg',ImgDiff.test)
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
