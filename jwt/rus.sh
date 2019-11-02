cd /home/app/code
echo 'Installing expres'
npm install express --save-dev
echo 'Installing body'
npm install body-parser --save-dev
echo 'Installing jwt'
npm install jsonwebtoken --save-dev
echo 'Running the server'
echo "Installing nodemon for clear cache.."
npm install nodemon --save-dev
echo "Installing bcrypt"
npm install bcrypt
echo "Installing validator"
npm install validator
echo "Installing env-cmd"
npm install env-cmd
exec /home/app/code/node_modules/.bin/nodemon server.js
