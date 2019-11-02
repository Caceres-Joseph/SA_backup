var mysql = require('mysql')

function DataBaseHandler(){
    this.connection = null
}

DataBaseHandler.prototype.createConnection = function () {
    this.connection = mysql.createConnection({
        host: 'db_archivos_traducidos',
        user: process.env.NODE_DB_USER,
        password: process.env.NODE_DB_PASSWORD,
        database: process.env.NODE_DB_NAME,
        port: 3306
    })

    this.connection.connect(function(err){
        if(err){
            console.error("Error connecting database "+err.stack)
            return null
        }
        console.log("connected to DB ")
    })
    return this.connection
}

module.exports = DataBaseHandler