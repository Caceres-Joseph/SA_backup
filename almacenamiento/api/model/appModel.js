'user strict';
var sql = require('./db.js');

exports.post_catalgo= function(){

    sql.query("INSERT INTO tasks set ?", newTask, function (err, res) {
            
        if(err) {
            console.log("error: ", err);
            result(err, null);
        }
        else{
            console.log(res.insertId);
            result(null, res.insertId);
        }
    });      
}

 