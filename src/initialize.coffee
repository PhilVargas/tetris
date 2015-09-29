React = require 'react'
window.$ = require 'jquery'
Tetris = require 'components/game'
ThemeSong = require 'components/theme-song'
TetrisStore = require 'stores/game'
TetrisAction = require 'actions/game'
SettingsStore = require 'stores/settings'
assign = require 'object-assign'

$(document).on 'ready', ->
  TetrisAction.init()
  React.render React.createElement(Tetris, assign {}, SettingsStore.getAll(), TetrisStore.getAll()), document.getElementById 'tetris-anchor'
  React.render(
    React.createElement(ThemeSong,
      isMuted: SettingsStore.get('isMuted')
      isPaused: SettingsStore.get('isPaused')
      hasGameBegun: TetrisStore.get('hasGameBegun')
    ), document.getElementById 'audio-anchor'
  )
