const mysql = require('mysql');
const connection = mysql.createConnection({
  host: 'db_almacenamiento',
  user: 'root',
  password: 'Chachas!123',
  database: 'sa_db',
  port: 3306
});


//exports.config = function(){
//  return connection;
//}

connection.connect(function(err) {
  if (err) {
    console.log(err);
    throw err;
  }
  console.log('Connected!');
});

module.exports = connection;