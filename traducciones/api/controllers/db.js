const mysql = require('mysql');
const connection = mysql.createConnection({
  host: 'db_traducciones',
  user: 'root',
  password: 'Chachas!123',
  database: 'sa_db',
  //port: 3306
});

module.exports = connection;
