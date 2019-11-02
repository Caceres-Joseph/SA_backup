
const eslint  = require('gulp-eslint');
gulp          = require('gulp');
var nodemon   = require('gulp-nodemon');
const zip     = require('gulp-zip');
//var mocha     = require('gulp-mocha');
//var istanbul  = require('gulp-istanbul')
const jasmine = require('gulp-jasmine');
function defaultTask(cb) {
  // place code for your default task here
  cb();
}

exports.default = defaultTask
//gulp.task('default', ['build'], defaultTask);
//gulp.task('build', ['lint','nodemon']);



gulp.task('lint', function(){
    return  gulp.src(['**/*.js','!**/node_modules/**'])
    .pipe(eslint({
        rules: {
            "indent": ["error", 4],
        "linebreak-style": ["error", "unix"],
        "quotes": ["error", "double"],
        "semi": ["error", "always"],

        // override default options for rules from base configurations
        "comma-dangle": ["error", "always"],
        "no-cond-assign": ["error", "always"],

        // disable rules from base configurations
        "no-console": "off",
        },
        globals: [
            'jQuery',
            '$'
        ],
        envs: [
            'browser'
        ]
    }))
    .pipe(eslint.result(result => {
        // Called for each ESLint result.
        console.log(`ESLint result: ${result.filePath}`);
        console.log(`# Messages: ${result.messages.length}`);
        console.log(`# Warnings: ${result.warningCount}`);
        console.log(`# Errors: ${result.errorCount}`);
    })).pipe(eslint.formatEach('compact', process.stderr));
});


gulp.task('test', function (){
    return gulp.src('spec/**/*.js')
        // gulp-jasmine works on filepaths so you can't have any plugins before it
        .pipe(jasmine())
	}
);


gulp.task("build", function (){
	return gulp.src(["**/**", "!**/node_modules"])
	.pipe(zip("archive.zip"))
	.pipe(gulp.dest("dist"));
})


gulp.task('build', gulp.series('lint'));

