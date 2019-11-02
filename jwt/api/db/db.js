const mysql = require('mysql');
const connection = mysql.createConnection({
  host: process.env.NODE_DB_HOST,
  user: process.env.NODE_DB_USER,
  password: process.env.NODE_DB_PASSWORD,
  database: process.env.NODE_DB_NAME,
  port: 3306
});

exports.config = function(){
  return connection;
}