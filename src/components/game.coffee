React = require 'react'
redux = require 'react-redux'

Board = require 'containers/board'
LegendPanel = require 'containers/legend'
SettingsPanel = require 'containers/settings-panel'
NextPiece = require 'containers/next-piece'
QueuePiece = require 'containers/queue-piece'
Attribution = require 'components/attribution'

Calculate = require 'helpers/calculator'
Store = require 'stores/game'

Settings = require 'helpers/settings'

$ = require('jquery')

Game = React.createClass
  displayName: 'Game'

  propTypes:
    hasGameBegun: React.PropTypes.bool.isRequired
    isGameOver: React.PropTypes.bool.isRequired
    isPaused: React.PropTypes.bool.isRequired
    level: React.PropTypes.number.isRequired
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
    return if @props.isPaused || !@props.hasGameBegun
    switch e.which
      when 38,87 then @props.dropPiece()
      when 69 then @props.rotateClockwise()
      when 81 then @props.rotateCounterClockwise()
      when 13 then @props.queuePiece()

  # Render functions #
  componentDidMount: ->
    $(document).on
      keydown: @handleKeyDown
      keyup: @handleKeyUp

  startGame: ->
    unless @props.hasGameBegun
      @props.start()
      $(document).on 'keyup', (e) =>
        @props.togglePause() if e.which == 32 && !@props.isGameOver
    setTimeout(@nextTick, Settings.initialTurnDelay)

  nextTick: ->
    delay = Calculate.turnDelay(@props.level)
    unless @props.isGameOver
      @props.nextTurn()
      setTimeout(@nextTick, delay)

  restartGame: ->
    @props.restartGame()
    setTimeout(@nextTick, Settings.initialTurnDelay)

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
            <Board {...@boardProps()} />
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

  # TODO: delete dependance on state
  boardProps: ->
    restartGame: @restartGame
    startGame: @startGame

module.exports = Game
