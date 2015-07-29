React = require 'react'
window.$ = require 'jquery'
Board = require 'components/board'
ThemeSong = require 'components/theme-song'
BoardStore = require 'stores/board'
BoardAction = require 'actions/board'
AudioStore = require 'stores/audio'
AudioAction = require 'actions/audio'
assign = require 'object-assign'

$(document).on 'ready', ->
  BoardAction.init()
  React.render React.createElement(Board, assign {}, AudioStore.getAll(), BoardStore.getAll()), document.getElementById 'board-anchor'
  React.render React.createElement(ThemeSong, isMuted: AudioStore.get('isMuted'), isPaused: BoardStore.get('isPaused')), document.getElementById 'audio-anchor'
