gulp = require 'gulp'
sass = require 'gulp-sass'
browserify = require 'browserify'
watchify = require 'watchify'
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

buildJs = ->
  browserBundle = browserify(browserifyOptions)
  browserBundle.transform jsxCoffee
  watcher = watchify(browserBundle)
  watcher.bundle().pipe(source('bundle.js')).pipe(buffer()).pipe(uglify()).pipe(gulp.dest(paths.build)).on 'end', ->
    watcher.close()

initializeWatcher = (bundleToWatch) ->
  watcher = watchify bundleToWatch
  watcher.on 'update', ->
    updateStart = Date.now()
    console.log 'Updating!'
    watcher.bundle().on('error', (e) ->
      displayError e
      return
    ).pipe(source('bundle.js')).pipe(gulp.dest(paths.build))
    console.log "Updated! #{Date.now() - updateStart} ms. Complete at #{new Date()}"
  watcher

watchJs = ->
  browserBundle = browserify(browserifyOptions)
  browserBundle.transform jsxCoffee
  watcher = initializeWatcher(browserBundle)
  watcher.bundle().on('error', (e) ->
    displayError e
    return
  ).pipe(source('bundle.js')).pipe gulp.dest(paths.build)

buildSass = ->
  gulp.src('./styles/sass/application.scss')
    .pipe(sass(outputStyle: 'compressed').on('error', sass.logError))
    .pipe(gulp.dest(paths.stylesRoot))

watchSass = ->
  gulp.watch(paths.sassFiles, ['build:sass'])
  .on 'change', (e) ->
    console.log "[watcher] File #{e.path.replace(/.*(?=sass)/,'')} was #{e.type} at #{new Date()}, compiling..."

module.exports.watch = watchJs
module.exports.build = buildJs
module.exports.buildSass  = buildSass
module.exports.watchSass  = watchSass
