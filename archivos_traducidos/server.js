const express = require('express')
const app = express()
port = 80

app.set('port',port)
app.set('view engine','ejs')
app.set('views', 'api/views')

const routes = require('./api/routes/routes')
routes(app)

app.use(express.static('api/public'))

app.listen(app.get('port'), () => {
    console.log('Corriendo Archivos Traducidos');
})