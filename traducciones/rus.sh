cd /home/app/code
echo 'Installing expres'
npm install express --save-dev
echo 'Installing body'
npm install body-parser --save-dev
echo "Installing mysql driver"
npm install mysql --save-dev
echo "Installing nodemon for clear cache.."
npm install nodemon --save-dev
echo 'Installing jwt'
npm install jsonwebtoken --save-dev
npm install cookie-parser --save-dev
exec /home/app/code/node_modules/.bin/nodemon server.js
