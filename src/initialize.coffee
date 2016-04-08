React = require 'react'
ReactDOM = require 'react-dom'
window.$ = require 'jquery'
Tetris = require 'containers/game'
ThemeSong = require 'components/theme-song'
TetrisStore = require 'stores/game'
TetrisAction = require 'actions/game'
SettingsStore = require 'stores/settings'
assign = require 'object-assign'

store = require 'reducers/store'
redux = require 'react-redux'
Provider = redux.Provider

$(document).on 'ready', ->
  ReactDOM.render <Provider store={store}><Tetris {...SettingsStore.getAll()} /></Provider>, document.getElementById 'tetris-anchor'
  # ReactDOM.render(
  #   React.createElement(ThemeSong,
  #     isMuted: SettingsStore.get('isMuted')
  #     isPaused: SettingsStore.get('isPaused')
  #     hasGameBegun: TetrisStore.get('hasGameBegun')
  #   ), document.getElementById 'audio-anchor'
  # )
