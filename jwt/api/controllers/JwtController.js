const jwt          = require('jsonwebtoken');
const values       = require("../models/User");
const fs           = require('fs');

const privateKey   = fs.readFileSync('/home/app/key/privatekey.ssh', 'utf8');
const publicKey    = fs.readFileSync('/home/app/key/publickey.ssh', 'utf8');


console.log(publicKey + "t");

exports.initJwt = function(req, res){
	res.send('Servidor de auth');
}

exports.getToken = function(req, res){
	var signOptions = {
		expiresIn: "10h",	
		algorithm:  "RS256"
	};
	let service    = findService(req.body.clientid);
	let payload    = setPayload(service);
	console.log("este es payload...");
	//console.log(payload);
	let token      = jwt.sign(payload, privateKey, signOptions);
	let legit      = jwt.verify(token, publicKey, signOptions);
	//console.log("this is the token: " + token);
	//console.log(legit);
	//console.log(jwt.decode(token, {complete:true}));
	if(service === false)
		return res.send({
			estado: 404,
			mensaje: "Error credenciales incorrectas, jwtController linea 41"
		});
	return res.json(
			{
				estado: 200,
				mensaje: "ok",
				data: {
					token : token	
				},
				"token" : token
			}
	);
}
	
function setPayload(service){
	console.log(service);
	return {
		"auth" : true,
		"clientid" : service.clientid,
		"scopes" : service.scopes		
	}
}

function findService(service){
	//console.log(values.values[0]);
	for (var i = values.values.length - 1; i >= 0; i--) {
		let clientid = values.values[i].clientid;
		if(values.values[i].clientid == service)
			return values.values[i];
	}
	return false;
}

