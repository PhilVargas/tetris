gulp = require 'gulp'
clean = require 'del'
merge = require 'merge-stream'
ghPages = require 'gulp-gh-pages'
sass = require 'gulp-sass'
browserify = require 'browserify'
uglify = require 'gulp-uglify'
buffer = require 'vinyl-buffer'
source = require 'vinyl-source-stream'
paths = require './filepaths.coffee'
jsxCoffee = require 'coffee-reactify'
displayError = paths.displayError

browserifyOptions =
  entries: paths.entries
  basedir: paths.jsRoot
  paths: paths.includes
  extensions: ['.js', '.coffee']
  debug: true
  cache: {}
  packageCache: {}
  fullPaths: true

buildJs = (destination)->
  browserify(browserifyOptions)
    .transform(jsxCoffee)
    .bundle()
    .on('error', (e) ->
      displayError(e)
    )
    .pipe(source('bundle.js'))
    .pipe(gulp.dest(destination))

watchJs = ->
  buildJs(paths.build)
  console.log("[watcher] Bundle initialized at #{new Date()}")
  gulp.watch paths.jsFiles, (e) ->
    buildJs(paths.build)
    console.log("[watcher] File #{e.path.replace(/.*(?=coffee)/, '')} was #{e.type} at #{new Date()}, compiling...")

buildSass = (destination, outputStyle = 'nested') ->
  gulp.src('./styles/sass/application.scss')
    .pipe(sass(outputStyle: outputStyle)
    .on('error', sass.logError))
    .pipe(gulp.dest(destination))

watchSass = ->
  buildSass(paths.stylesRoot, 'nested')
  gulp.watch paths.sassFiles, (e) ->
    buildSass(paths.stylesRoot, 'nested')
    console.log "[watcher] File #{e.path.replace(/.*(?=sass)/,'')} was #{e.type} at #{new Date()}, compiling..."

cleanScripts = ->
  clean([
    './dist'
  ])

deployPrep = ->
  merge buildSass(paths.stylesDeployRoot, 'compressed'),
    buildJs(paths.jsDeployRoot),
    gulp.src('README.md').pipe(gulp.dest('./dist/')),
    gulp.src('favicon.ico').pipe(gulp.dest('./dist/')),
    gulp.src('public/**/*').pipe(gulp.dest('./dist/')),
    gulp.src('index.html').pipe(gulp.dest('./dist/'))

deployProd = ->
  gulp.src('./dist/**/*').pipe(ghPages(force: true))

module.exports.watch = watchJs
module.exports.build = buildJs.bind(null, paths.build)
module.exports.buildSass  = buildSass.bind(null, paths.stylesRoot, 'compressed')
module.exports.watchSass  = watchSass

module.exports.deploy =
  clean: cleanScripts
  prep: deployPrep
  prod: deployProd
