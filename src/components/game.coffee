React = require 'react'
redux = require 'react-redux'

Board = require 'containers/board'
LegendPanel = require 'containers/legend-panel'
SettingsPanel = require 'containers/settings-panel'
NextPiece = require 'containers/next-piece'
QueuePiece = require 'containers/queue-piece'
Attribution = require 'components/attribution'

Calculate = require 'helpers/calculator'

Settings = require 'helpers/settings'

$ = require('jquery')

Game = React.createClass
  displayName: 'Game'

  propTypes:
    dropPiece: React.PropTypes.func.isRequired
    hasGameBegun: React.PropTypes.bool.isRequired
    isGameOver: React.PropTypes.bool.isRequired
    isPaused: React.PropTypes.bool.isRequired
    queuePiece: React.PropTypes.func.isRequired
    rotateClockwise: React.PropTypes.func.isRequired
    rotateCounterClockwise: React.PropTypes.func.isRequired
    setPieceIndeces: React.PropTypes.func.isRequired
    togglePause: React.PropTypes.func.isRequired
    xIndex: React.PropTypes.number.isRequired
    yIndex: React.PropTypes.number.isRequired

  # 37, 65 left
  # 39, 68 right
  # 40, 83 down
  handleKeyDown: (e) ->
    return if @props.isPaused || !@props.hasGameBegun
    switch e.which
      when 37,65 then @props.setPieceIndeces(xIndex: @props.xIndex - 1, yIndex: @props.yIndex)
      when 39,68 then @props.setPieceIndeces(xIndex: @props.xIndex + 1, yIndex: @props.yIndex)
      when 40,83 then @props.setPieceIndeces(yIndex: @props.yIndex + 1, xIndex: @props.xIndex)

  # 38 87, up w
  # 69 q
  # 81 e
  # 13 enter
  handleKeyUp: (e) ->
    if !@props.isPaused || !@props.hasGameBegun
      switch e.which
        when 38,87 then @props.dropPiece()
        when 69 then @props.rotateClockwise()
        when 81 then @props.rotateCounterClockwise()
        when 13 then @props.queuePiece()
    @props.togglePause() if e.which == 32 && !@props.isGameOver && @props.hasGameBegun

  # Render functions #
  componentDidMount: ->
    $(document).on
      keydown: @handleKeyDown
      keyup: @handleKeyUp

  componentWillUnmount: ->
    $(document).off 'keyup'

  render: ->
    <div id="game-container">
      <div className="row">
        <div className="large-11 columns large-centered">
          <div className="row">
            <div className="columns large-3">
              <LegendPanel />
              <SettingsPanel />
            </div>
            <Board />
            <div className="columns large-3 end">
              <div className="row">
                <div className="columns callout panel radius">
                  <div className="row">
                    <NextPiece />
                  </div>
                  <div className="row">
                    <QueuePiece />
                  </div>
                </div>
              </div>
              <div className="row">
                <div className="columns panel radius">
                  <Attribution />
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

module.exports = Game
