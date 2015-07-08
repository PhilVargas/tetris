React = require 'react'
window.$ = require 'jquery'
Board = require 'components/board'
BoardStore = require 'stores/board'
BoardAction = require 'actions/board'

$(document).on 'ready', ->
  BoardAction.init()
  React.render React.createElement(Board, BoardStore.getAll()), document.getElementById 'board-container'
