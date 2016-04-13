React = require 'react'
SettingsStore = require 'stores/settings'
TetrisStore = require 'stores/game'

ThemeSong = React.createClass
  displayName: 'ThemeSong'

  propTypes:
    isMuted: React.PropTypes.bool.isRequired
    isPaused: React.PropTypes.bool.isRequired
    hasGameBegun: React.PropTypes.bool.isRequired

  componentDidUpdate: ->
    if @props.isMuted || @props.isPaused || !@props.hasGameBegun
      @refs.themeSong.pause()
    else
      @refs.themeSong.play()

  render: ->
    <div className="theme-song-container">
      <audio ref='themeSong' src="https://raw.githubusercontent.com/PhilVargas/tetris/master/public/assets/music/Tetris%20Theme%20-%20Long.ogg" loop></audio>
    </div>

module.exports = ThemeSong
