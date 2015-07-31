React = require 'react'

cx = require 'classnames'

Overlay = React.createClass
  displayName: 'Overlay'

  propTypes:
    hasGameBegun: React.PropTypes.bool.isRequired
    isGameOver: React.PropTypes.bool.isRequired
    isPaused: React.PropTypes.bool.isRequired
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

  render: ->
    <div id='board-overlay' className={ @containerClass() }>
      <button id='start-button' className={ @startButtonClass() } onClick={ @props.startGame }>Start!</button>
      <div id="pause-display-container" className={ @pauseIconClass() }>
        <i className="icon-pause icon-4x display-text"></i>
      </div>
      <div id='game-over-container' className={ @gameOverClass() }>
        <div className='display-text row'>Game Over!</div>
        <div className='display-text row'>Score: { @props.score }</div>
        <button id='restart-button' className='btn tiny secondary radius' onClick={ @props.restartGame }>New Game</button>
      </div>
    </div>

module.exports = Overlay
