React = require 'react'
$ = require 'jquery'
Board = require './board'

$(document).on 'ready', ->
  React.render React.createElement(Board, {}), document.getElementById 'board-container'
