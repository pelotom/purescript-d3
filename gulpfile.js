'use strict'

var gulp        = require('gulp')
  , purescript  = require('gulp-purescript')
  , concat      = require('gulp-concat')
  , rimraf      = require('rimraf')
  ;

var paths = {
  src: 'src/**/*.purs',
  ffi: 'src/**/*.js',
  dest: 'build/output',
  bowerSrc: 'bower_components/purescript-*/src/**/*.purs',
  bowerFfi:  'bower_components/purescript-*/src/**/*.js',
  manualReadme: 'docsrc/README.md',
  apiDest: 'build/API.md',
  readmeDest: 'README.md'
};

gulp.task('clean', function (cb) {
  return rimraf('build/', cb);
});

gulp.task('compile', ['clean'], function() {
  return purescript.psc({
    // Compiler options
    src: [paths.src, paths.bowerSrc],
    ffi: [paths.ffi, paths.bowerFfi],
    output: paths.dest
  });
});

gulp.task('generateDocs', ['compile'], function() {
  return purescript.pscDocs({
      src: [paths.src, paths.bowerSrc]
    })
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
