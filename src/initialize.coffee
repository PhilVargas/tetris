React = require 'react'
ReactDOM = require 'react-dom'
window.$ = require 'jquery'
Tetris = require 'containers/game'
ThemeSong = require 'containers/theme-song'
assign = require 'object-assign'

store = require 'reducers/store'
redux = require 'react-redux'
Provider = redux.Provider

$(document).on 'ready', ->
  ReactDOM.render <Provider store={store}><Tetris /></Provider>, document.getElementById 'tetris-anchor'
  ReactDOM.render <Provider store={store}><ThemeSong /></Provider>, document.getElementById 'audio-anchor'
