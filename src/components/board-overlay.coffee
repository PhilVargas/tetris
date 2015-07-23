React = require 'react'

cx = require 'classnames'

Overlay = React.createClass
  displayName: 'Overlay'

  propTypes:
    hasGameBegun: React.PropTypes.bool.isRequired
    isPaused: React.PropTypes.bool.isRequired
    startGame: React.PropTypes.func.isRequired

  containerClass: ->
    cx
      active: !@props.hasGameBegun || @props.isPaused

  startButtonClass: ->
    cx "btn tiny radius secondary",
      hide: @props.hasGameBegun

  pauseIconClass: ->
    cx
      hide: !@props.hasGameBegun || !@props.isPaused

  render: ->
    <div id='board-overlay' className={ @containerClass() }>
      <button id='start-button' className={ @startButtonClass() } onClick={ @props.startGame }>Start!</button>
      <div id="pause-display-container" className={ @pauseIconClass() }>
        <i className="icon-pause icon-4x"></i>
      </div>
    </div>

module.exports = Overlay
