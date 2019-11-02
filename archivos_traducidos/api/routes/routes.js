module.exports  = function(app){
	var main = require('../controllers/ArchivosTraducidosController')
	app.route('/').get(main.initArchivosTraducidos)
	app.route('/init').get(main.initFEArchivosTraducidos)
	app.route('/get/listaComplementos').get(main.listaComplementos)
	app.route('/lista').get(main.listaFEComplementos)
	app.route('/get/listadoDeLocalizaciones/:strComplement').get(main.listaDeLocalizaciones)
	app.route('/porLocalizacion/:loc').get(main.listaFEDeLocalizaciones)
	app.route('/get/DescargaMo/:strComplement/:strPath').get(main.descargaMo)
	app.route('/get/DescargaPo/:strComplement/:strPath').get(main.descargaPo)
	app.route('/post/complementoTraducido').post(main.ComplementoTraducido)
}
