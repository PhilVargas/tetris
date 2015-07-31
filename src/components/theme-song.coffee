React = require 'react'
SettingsStore = require 'stores/settings'
GameStore = require 'stores/game'
Action = require 'actions/settings'
$ = require 'jquery'

ThemeSong = React.createClass
  displayName: 'ThemeSong'

  propTypes:
    isMuted: React.PropTypes.bool.isRequired
    isPaused: React.PropTypes.bool.isRequired

  getInitialState: ->
    isMuted: @props.isMuted
    isPaused: @props.isPaused

  componentDidMount: ->
    GameStore.bindChange @stateChange
    SettingsStore.bindChange @stateChange

  stateChange: ->
    @setState isPaused: GameStore.get('isPaused')
    @setState SettingsStore.getAll()

  componentDidUpdate: ->
    if @state.isMuted || @state.isPaused
      @refs.themeSong.getDOMNode().pause()
    else
      @refs.themeSong.getDOMNode().play()

  componentWillUnmount: ->
    GameStore.unbindChange @stateChange
    SettingsStore.unbindChange @stateChange

  render: ->
    <div className="theme-song-container">
      <audio ref='themeSong' src="https://raw.githubusercontent.com/PhilVargas/tetris/master/public/assets/music/Tetris%20Theme%20-%20Long.ogg" autoPlay loop></audio>
    </div>

module.exports = ThemeSong
