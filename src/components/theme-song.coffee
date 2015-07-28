React = require 'react'
AudioStore = require 'stores/audio'
BoardStore = require 'stores/board'
Action = require 'actions/audio'
$ = require 'jquery'

ThemeSong = React.createClass
  displayName: 'ThemeSong'

  propTypes:
    isPaused: React.PropTypes.bool.isRequired
    isMuted: React.PropTypes.bool.isRequired

  getInitialState: ->
    isPaused: @props.isPaused
    isMuted: @props.isMuted

  componentDidMount: ->
    BoardStore.bindChange @stateChange
    AudioStore.bindChange @stateChange

  stateChange: ->
    @setState isPaused: BoardStore.get('isPaused')
    @setState AudioStore.getAll()

  componentDidUpdate: ->
    if @state.isMuted || @state.isPaused
      @refs.themeSong.getDOMNode().pause()
    else
      @refs.themeSong.getDOMNode().play()

  componentWillUnmount: ->
    BoardStore.unbindChange @stateChange
    AudioStore.unbindChange @stateChange

  render: ->
    <div className="theme-song-container">
      <audio ref='themeSong' src="https://raw.githubusercontent.com/PhilVargas/tetris/master/public/assets/music/Tetris%20Theme%20-%20Long.ogg" autoPlay loop></audio>
    </div>

module.exports = ThemeSong
