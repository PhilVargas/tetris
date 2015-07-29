React = require 'react'
window.$ = require 'jquery'
Tetris = require 'components/game'
ThemeSong = require 'components/theme-song'
TetrisStore = require 'stores/game'
TetrisAction = require 'actions/game'
AudioStore = require 'stores/audio'
AudioAction = require 'actions/audio'
assign = require 'object-assign'

$(document).on 'ready', ->
  TetrisAction.init()
  React.render React.createElement(Tetris, assign {}, AudioStore.getAll(), TetrisStore.getAll()), document.getElementById 'tetris-anchor'
  React.render React.createElement(ThemeSong, isMuted: AudioStore.get('isMuted'), isPaused: TetrisStore.get('isPaused')), document.getElementById 'audio-anchor'
