cd /home/app/code

t=0
while [ $t -eq 0 ]
do
	if [ "`ping -c 1 localhost`" ]
	then
	  echo 1
	  t=1
	else
	  echo 0
	fi
	sleep 1
done
echo "almacenamiento is ready running esb"
echo "installing express"
npm install express --save-dev
echo "installing body-parser"
npm install body-parser --save-dev
echo "Installing request"
npm install request --save-dev
echo "Instaling mysql handler"
npm install mysql --save-dev
echo "Installing nodemon for clear cache.."
npm install nodemon --save-dev
#echo "Installing factory-request"
#npm install request-factory --save-dev
npm install --save request-promise
npm install --save-dev axios
echo 'Installing jwt'
npm install jsonwebtoken --save-dev
exec /home/app/code/node_modules/.bin/nodemon server.js