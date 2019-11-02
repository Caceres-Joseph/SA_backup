const jwt          = require('jsonwebtoken');
var publicKey      = `-----BEGIN PUBLIC KEY-----
MFswDQYJKoZIhvcNAQEBBQADSgAwRwJAUscQhu2s5pXH7LncPrSYxwTh+ZQ1nRNI
TOci7xhQrcDp/Mic8BdOxbcYxSKoF86vy66Donxsjx1LCXIrb4UrpwIDAQAB
-----END PUBLIC KEY-----`;
const fs           = require('fs');
var reda = null;
try{
reda = fs.readFileSync('/home/app/key/publickey.ssh', 'utf8');
}
catch(e){
	console.log(e);
}
if(reda){
	publicKey = reda;
	console.log('entor');
	console.log(publicKey);
}
else{
	console.log("Theres is not public key configure, using the public key by default");
}


const verifyOptions = {
	expiresIn: "10h",
	algorithm:  "RS256"
};

exports.verifyToken = function(token){
	try{
		return jwt.verify(token, publicKey, verifyOptions);
	}
	catch(e){
		return false;
	}
}

exports.decode = function(token){
	return jwt.decode(token, {complete:true});
}