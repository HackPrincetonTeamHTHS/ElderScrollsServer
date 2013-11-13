###
Module dependencies.
###

port = process.env.PORT || 3000

require 'coffee-script'
coffeescript = require('connect-coffee-script');
lessmiddleware = require('less-middleware');
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
app.use(lessmiddleware({src: __dirname+'/client',compress:true,debug:true,force:true}));
app.use(coffeescript({src: __dirname,bare: true}));
app.use('/',express.static(path.join(__dirname, 'client')));
app.use('/classes', express.static(path.join(__dirname, 'classes')));



if ('development' == app.get('env'))
  app.use express.errorHandler()

if ('production' == app.get('env'))
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
  console.log "Root directory at", __dirname
  console.log "Starting up real time server"

  Server = require './classes/Server'
  s = new Server(io)

  importRoute = require './import'
  app.get '/import', importRoute
