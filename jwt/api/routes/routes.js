module.exports  = function(app){
	var main = require('../controllers/JwtController');	
	app.route('/').get(main.initJwt);
	app.route('/getToken').post(main.getToken);
	app.route('/post/autorizacion').post(main.getToken);
}