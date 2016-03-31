React = require 'react'
ReactDOM = require 'react-dom'
window.$ = require 'jquery'
Tetris = require 'components/game'
ThemeSong = require 'components/theme-song'
TetrisStore = require 'stores/game'
TetrisAction = require 'actions/game'
SettingsStore = require 'stores/settings'
assign = require 'object-assign'

$(document).on 'ready', ->
  TetrisAction.init()
  ReactDOM.render React.createElement(Tetris, assign {}, SettingsStore.getAll(), TetrisStore.getAll()), document.getElementById 'tetris-anchor'
  ReactDOM.render(
    React.createElement(ThemeSong,
      isMuted: SettingsStore.get('isMuted')
      isPaused: SettingsStore.get('isPaused')
      hasGameBegun: TetrisStore.get('hasGameBegun')
    ), document.getElementById 'audio-anchor'
  )
