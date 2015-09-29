React = require 'react'

cx = require 'classnames'

Overlay = React.createClass
  displayName: 'Overlay'

  propTypes:
    hasGameBegun: React.PropTypes.bool.isRequired
    isGameOver: React.PropTypes.bool.isRequired
    isPaused: React.PropTypes.bool.isRequired
    isMuted: React.PropTypes.bool.isRequired
    restartGame: React.PropTypes.func.isRequired
    score: React.PropTypes.number.isRequired
    startGame: React.PropTypes.func.isRequired

  containerClass: ->
    cx
      active: !@props.hasGameBegun || @props.isPaused || @props.isGameOver

  startButtonClass: ->
    cx "btn tiny radius secondary",
      hide: @props.hasGameBegun

  pauseIconClass: ->
    cx
      hide: !@props.hasGameBegun || !@props.isPaused

  gameOverClass: ->
    cx
      hide: !@props.isGameOver

  audioDisplayClass: ->
    cx 'display-text',
      hide: @props.hasGameBegun

  audioDisplayText: ->
    cx
      Enabled: !@props.isMuted
      Disabled: @props.isMuted

  render: ->
    <div id='board-overlay' className={ @containerClass() }>
      <div id='start-container'>
        <button id='start-button' className={ @startButtonClass() } onClick={ @props.startGame }>Start!</button>
        <div id='audio-display-text' className={ @audioDisplayClass() }>(Audio is { @audioDisplayText() })</div>
      </div>
      <div id="pause-display-container" className={ @pauseIconClass() }>
        <i className="fa fa-pause fa-4x display-text"></i>
      </div>
      <div id='game-over-container' className={ @gameOverClass() }>
        <div className='display-text row'>Game Over!</div>
        <div className='display-text row'>Score: { @props.score }</div>
        <button id='restart-button' className='btn tiny secondary radius' onClick={ @props.restartGame }>New Game</button>
      </div>
    </div>

module.exports = Overlay
