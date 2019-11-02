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
#echo 'Cargando la base de datos'
#mysql -u $NODE_DB_USER -p $NODE_DB_PASSWORD -h  < script/setup.sql
exec /home/app/code/node_modules/.bin/nodemon server.js
