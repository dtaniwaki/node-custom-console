gulp = require 'gulp'
coffeelint = require 'gulp-coffeelint'
coffee = require 'gulp-coffee'
sourcemaps = require 'gulp-sourcemaps'
mocha = require 'gulp-mocha'

gulp.task 'lint', (done)->
  gulp.src ['src/**/*.coffee', 'test/**/*.coffee']
  .pipe coffeelint opt: (require "./_lintopts")
  .pipe coffeelint.reporter()

gulp.task 'compile', (done)->
  gulp.src ['src/**/*.coffee']
    .pipe sourcemaps.init()
    .pipe coffee {bare: true, nodejs: true}
    .pipe sourcemaps.write '.',
      addComment: true
      sourceRoot: '/src'
    .pipe gulp.dest 'lib'

gulp.task 'test', (done) ->
  gulp.src ['test/**/*.coffee'], {read: false}
    .pipe mocha
      reporter: 'spec',
      ui: 'bdd',
      timeout: 3000

gulp.task 'build', ['lint', 'compile']

gulp.task 'default', ['build']
