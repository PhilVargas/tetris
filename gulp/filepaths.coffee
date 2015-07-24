path = require('path')

BASE_DIR = 'src'
STYLES_BASE_DIR = 'styles'
SASS_BASE_DIR = 'styles/sass'
VENDOR_ROOT = 'node_modules'

displayError = (error) ->
  errorMessage = "[#{error.plugin}] #{error.message.replace('\n', '')}"
  if error.fileName
    errorMessage += " in #{error.fileName}"
  if error.lineNumber
    errorMessage += " on line #{error.lineNumber}"

  console.error errorMessage

module.exports =
  build: BASE_DIR
  displayError: displayError
  entries: ['index.coffee']
  includes: ['./']
  stylesRoot: STYLES_BASE_DIR
  sassRoot: SASS_BASE_DIR
  sassFiles: "#{SASS_BASE_DIR}/**/*.scss"
  jsRoot: BASE_DIR
  jsVendor: VENDOR_ROOT
  root: BASE_DIR
