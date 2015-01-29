'use strict'

var gulp      	= require('gulp')
  , purescript 	= require('gulp-purescript')
  , concat 		 	= require('gulp-concat')
	, rimraf 			= require('rimraf')
  ;

var paths = {
	src: 'src/**/*.purs',
	dest: 'build/output',
	bowerSrc: [
	  'bower_components/purescript-*/src/**/*.purs'
	],
	manualReadme: 'docsrc/README.md',
	apiDest: 'build/API.md',
	readmeDest: 'README.md'
};

gulp.task('clean', function (cb) {
  return rimraf('build/', cb);
});

gulp.task('compile', ['clean'], function() {
	var psc = purescript.pscMake({
		// Compiler options
		output: paths.dest
	});
	psc.on('error', function(e) {
		console.error(e.message);
		psc.end();
	});
	return gulp.src([paths.src].concat(paths.bowerSrc))
		.pipe(psc)
});

gulp.task('generateDocs', ['compile'], function() {
	return gulp.src(paths.src)
	  .pipe(purescript.pscDocs())
	  .pipe(gulp.dest(paths.apiDest))
	  ;
});

gulp.task('concatDocs', ['generateDocs'], function () {
	return gulp.src([paths.manualReadme, paths.apiDest])
		.pipe(concat(paths.readmeDest))
		.pipe(gulp.dest(''))
		;
});

gulp.task('docs', ['generateDocs', 'concatDocs']);

gulp.task('watch', ['build'], function() {
	gulp.watch(paths.src, ['build']);
	gulp.watch(paths.manualReadme, ['concatDocs']);
});

gulp.task('build', ['compile', 'docs']);

gulp.task('default', ['build']);
