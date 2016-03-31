React = require 'react'
SettingsStore = require 'stores/settings'
TetrisStore = require 'stores/game'

ThemeSong = React.createClass
  displayName: 'ThemeSong'

  propTypes:
    isMuted: React.PropTypes.bool.isRequired
    isPaused: React.PropTypes.bool.isRequired
    hasGameBegun: React.PropTypes.bool.isRequired

  getInitialState: ->
    isMuted: @props.isMuted
    isPaused: @props.isPaused
    hasGameBegun: @props.hasGameBegun

  componentDidMount: ->
    SettingsStore.bindChange @stateChange
    TetrisStore.bindChange @stateChange

  stateChange: ->
    @setState
      isMuted: SettingsStore.get('isMuted')
      isPaused: SettingsStore.get('isPaused')
      hasGameBegun: TetrisStore.get('hasGameBegun')

  componentDidUpdate: ->
    if @state.isMuted || @state.isPaused || !@state.hasGameBegun
      @refs.themeSong.pause()
    else
      @refs.themeSong.play()

  componentWillUnmount: ->
    SettingsStore.unbindChange @stateChange
    TetrisStore.unbindChange @stateChange

  render: ->
    <div className="theme-song-container">
      <audio ref='themeSong' src="https://raw.githubusercontent.com/PhilVargas/tetris/master/public/assets/music/Tetris%20Theme%20-%20Long.ogg" loop></audio>
    </div>

module.exports = ThemeSong
