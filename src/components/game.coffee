React = require 'react'
redux = require 'react-redux'

Board = require 'containers/board'
Cell = require 'components/cell'
Legend = require 'components/legend'
SettingsPanel = require 'containers/settings-panel'
NextPiece = require 'containers/next-piece'
QueuePiece = require 'containers/queue-piece'
Attribution = require 'components/attribution'

Calculate = require 'helpers/calculator'
Store = require 'stores/game'
Action = require 'actions/game'
SettingsStore = require 'stores/settings'
SettingsAction = require 'actions/settings'

Settings = require 'helpers/settings'
Calculate = require 'helpers/calculator'

$ = require('jquery')
cx = require 'classnames'

Game = React.createClass
  displayName: 'Game'

  propTypes:
    boardDisplaySize: React.PropTypes.number.isRequired
    cells: React.PropTypes.array.isRequired
    currentPieceType: React.PropTypes.string.isRequired
    ghostYIndex: React.PropTypes.number.isRequired
    hasGameBegun: React.PropTypes.bool.isRequired
    isColorblindActive: React.PropTypes.bool.isRequired
    isGameOver: React.PropTypes.bool.isRequired
    isGhostVisible: React.PropTypes.bool.isRequired
    isMuted: React.PropTypes.bool.isRequired
    isPaused: React.PropTypes.bool.isRequired
    linesCleared: React.PropTypes.number.isRequired
    nextPieceType: React.PropTypes.string.isRequired
    queuePieceType: React.PropTypes.string.isRequired
    rotation: React.PropTypes.number.isRequired
    score: React.PropTypes.number.isRequired
    scoreThisTurn: React.PropTypes.number.isRequired
    shouldAllowQueue: React.PropTypes.bool.isRequired
    turnCount: React.PropTypes.number.isRequired
    xIndex: React.PropTypes.number.isRequired
    yIndex: React.PropTypes.number.isRequired

  getInitialState: ->
    boardDisplaySize: @props.boardDisplaySize
    cells: @props.cells
    currentPieceType: @props.currentPieceType
    ghostYIndex: @props.ghostYIndex
    hasGameBegun: @props.hasGameBegun
    isColorblindActive: @props.isColorblindActive
    isGameOver: @props.isGameOver
    isGhostVisible: @props.isGhostVisible
    isMuted: @props.isMuted
    isPaused: @props.isPaused
    linesCleared: @props.linesCleared
    nextPieceType: @props.nextPieceType
    queuePieceType: @props.queuePieceType
    rotation: @props.rotation
    score: @props.score
    scoreThisTurn: @props.scoreThisTurn
    shouldAllowQueue: @props.shouldAllowQueue
    turnCount: @props.turnCount
    xIndex: @props.xIndex
    yIndex: @props.yIndex

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
      # when 13 then @props.queuePiece()

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
    if !@props.isGameOver || !@props.isPaused
      @props.nextTurn()
      setTimeout(@nextTick, delay)

  restartGame: ->
    # Action.restartGame()
    setTimeout(@nextTick, Settings.initialTurnDelay)

  componentWillUnmount: ->
    $(document).off 'keyup'

  render: ->
    <div id="game-container">
      <div className="row">
        <div className="large-11 columns large-centered">
          <div className="row">
            <div className="columns large-3">
              <Legend {...@legendProps()} />
              <SettingsPanel />
            </div>
            <Board {...@boardProps()} />
            <div className="columns large-3 end">
              <div className="row">
                <div className="columns callout panel radius">
                  <div className="row">
                    <NextPiece {...@nextPieceProps()} />
                  </div>
                  <div className="row">
                    <QueuePiece {...@queuePieceProps()} />
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
  nextPieceProps: ->
    pieceType: @state.nextPieceType
    isDisabled: !@state.hasGameBegun

  queuePieceProps: ->
    pieceType: @state.queuePieceType
    canQueuePiece: @state.canQueuePiece

  legendProps: ->
    level: @props.level
    linesCleared: @props.linesCleared
    score: @props.score
    scoreThisTurn: @props.scoreThisTurn

  boardProps: ->
    # cells: @state.cells
    # currentPieceType: @state.currentPieceType
    # ghostYIndex: @state.ghostYIndex
    # hasGameBegun: @state.hasGameBegun
    # isGameOver: @state.isGameOver
    restartGame: @restartGame
    # rotation: @state.rotation
    # score: @state.score
    startGame: @startGame
    # xIndex: @state.xIndex
    # yIndex: @state.yIndex

module.exports = Game
