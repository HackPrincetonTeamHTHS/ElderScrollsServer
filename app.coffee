###
Module dependencies.
###

port = process.env.PORT || 3000

require 'coffee-script'
express = require('express')
routes = require('./routes/')
user = require('./routes/user')
http = require('http')
path = require('path')

requirejs = require 'requirejs'
requirejs.config { nodeRequire: require }

app = express()

app.configure(() ->
  app.set('port', port);
  app.set('views', __dirname + '/views');
  app.set('view engine', 'ejs');
  app.use(express.favicon());
  app.use(express.logger('dev'));
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(app.router);
  app.use(require('less-middleware')({ src: __dirname + '/public' }));
  app.use(express.static(path.join(__dirname, 'public')));
  app.use('/classes', express.static(path.join(__dirname, 'classes')));
)

app.configure('development', () ->
  app.use(express.errorHandler());
)

app.get('/', routes.index);
app.get('/users', user.list);

server = http.createServer(app)
io = require('socket.io').listen(server)
server.listen(app.get('port'), () ->
  console.log("Express server listening on port " + app.get('port'))
)

console.log "Initializing database connection"
requirejs ['./classes/Database'], (database) ->
  database.onReady () ->
    console.log "Ready"
    console.log "Starting up real time server"

    requirejs ['./classes/Server'], (Server) ->
      s = new Server(io)
