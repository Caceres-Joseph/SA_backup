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
});*/
/*const mysql = require('mysql');
const connection = mysql.createConnection({
  host: 'db_almacenamiento',
  user: 'root',
  password: 'Chachas!123',
  database: 'sa_db',
  port: 3306
});

connection.connect((err) => {
  if (err) {
    console.log(err);
    throw err;
  }
  console.log('Connected!');
});*/



console.log('test');
app.listen(port);
console.log('Corriendo almacenamiento');