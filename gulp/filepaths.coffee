path = require('path')

BASE_DIR = 'src'
STYLES_BASE_DIR = 'styles'
JS_DEPLOY_DIR = 'dist/src'
STYLES_DEPLOY_DIR = 'dist/styles'
SASS_BASE_DIR = 'styles/sass'
VENDOR_ROOT = 'node_modules'

displayError = (error) ->
  console.log error.message

module.exports =
  build: BASE_DIR
  jsDeployRoot: JS_DEPLOY_DIR
  stylesDeployRoot: STYLES_DEPLOY_DIR
  displayError: displayError
  entries: ['initialize.coffee']
  includes: ['./']
  stylesRoot: STYLES_BASE_DIR
  sassRoot: SASS_BASE_DIR
  sassFiles: "#{SASS_BASE_DIR}/**/*.scss"
  jsFiles: [
    "#{BASE_DIR}/**/*.coffee",
    "!#{BASE_DIR}/bundle.js"
  ]
  jsRoot: BASE_DIR
  jsVendor: VENDOR_ROOT
  root: BASE_DIR
