  var createError = require('http-errors');
  var path = require('path');
  var express = require('express');
  var cookieParser = require('cookie-parser');
  var logger = require('morgan'), 
  app = express(),
  port = 80,
  bodyParser = require('body-parser');

  // view engine setup
  app.set('views', path.join(__dirname, 'views'));
  app.set('view engine', 'jade');

  app.use(logger('dev'));
  app.use(express.json());
  app.use(express.urlencoded({ extended: false }));
  app.use(cookieParser());
  app.use(express.static(path.join(__dirname, 'public')));
  app.use(bodyParser.urlencoded({ extended: true }));
  app.use(bodyParser.json());

  var routes = require('./api/routes/routes'); //importando rutas
  routes(app); //registrando las rutas

  // catch 404 and forward to error handler
  app.use(function(req, res, next) {
    next(createError(404));
  });

  // error handler
  app.use(function(err, req, res, next) {
    // set locals, only providing error in development
    res.locals.message = err.message;
    res.locals.error = req.app.get('env') === 'development' ? err : {};

    // render the error page
    res.status(err.status || 500);
    res.render('error');
  });

  /*app.get('/', (req, res) => {
  	res.send('hola mundo');
  });*/
  console.log("Variableeeee : "+process.env.NODE_DB_HOST);
  app.listen(port);
  console.log('Corriendo traducciones');