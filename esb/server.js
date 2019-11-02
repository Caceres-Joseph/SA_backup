  var express = require('express'),
  app = express(),
  port = 80,
  bodyParser = require('body-parser');
  

  app.use(bodyParser.urlencoded({ extended: true }));
  app.use(bodyParser.json());

  var routes = require('./api/routes/routes'); //importando rutas
  routes(app); //registrando las rutas
  /*app.get('/', (req, res) => {
  	res.send('hola mundo');
  });
  */
  


  app.listen(port);
  console.log('Corriendo EBS 1');
