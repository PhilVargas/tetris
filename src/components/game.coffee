React = require 'react'

Board = require 'components/board'
Cell = require 'components/cell'
Legend = require 'components/legend'
SettingsPanel = require 'components/settings'
DisplayPiece = require 'components/display-piece'

Store = require 'stores/game'
SettingsStore = require 'stores/settings'
Action = require 'actions/game'
AudioStore = require 'stores/audio'
AudioAction = require 'actions/audio'

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
    cells: @props.cells
    boardDisplaySize: @props.boardDisplaySize
    currentPieceType: @props.currentPieceType
    ghostYIndex: @props.ghostYIndex
    hasGameBegun: @props.hasGameBegun
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
    return if @state.isPaused || !@state.hasGameBegun
    switch e.which
      when 37,65 then Action.setPieceIndeces(xIndex: @state.xIndex - 1, yIndex: @state.yIndex)
      when 39,68 then Action.setPieceIndeces(xIndex: @state.xIndex + 1, yIndex: @state.yIndex)
      when 40,83 then Action.setPieceIndeces(yIndex: @state.yIndex + 1, xIndex: @state.xIndex)

  # 38 87, up w
  # 69 q
  # 81 e
  # 13 enter
  handleKeyUp: (e) ->
    return if @state.isPaused || !@state.hasGameBegun
    switch e.which
      when 38,87 then Action.dropPiece()
      when 69 then Action.rotateClockwise()
      when 81 then Action.rotateCounterClockwise()
      when 13 then Action.queuePiece()

  # Render functions #
  componentDidMount: ->
    Store.bindChange @gameChanged
    AudioStore.bindChange @audioChanged
    $(document).on
      keydown: @handleKeyDown
      keyup: @handleKeyUp

  startGame: ->
    unless @state.hasGameBegun
      Action.startGame()
      $(document).on 'keyup', (e) ->
        Action.togglePause() if e.which == 32 && !Store.get('isGameOver')
    setTimeout(@nextTick, Settings.initialTurnDelay)

  nextTick: ->
    delay = Store.turnDelay()
    unless @state.isGameOver
      Action.nextTurn()
      setTimeout(@nextTick, delay)

  restartGame: ->
    Action.restartGame()
    setTimeout(@nextTick, Settings.initialTurnDelay)

  gameChanged: ->
    @setState Store.getAll()

  audioChanged: ->
    @setState AudioStore.getAll()

  componentWillUnmount: ->
    Store.unbindChange @gameChanged
    AudioStore.unbindChange @audioChanged
    $(document).off 'keyup'

  render: ->
    <div id="game-container">
      <div className="row">
        <div className="large-11 columns large-centered">
          <div className="row">
            <div className="columns large-3">
              <Legend {...@legendProps()} />
              <SettingsPanel {...@settingsProps()} />
            </div>
            <Board {...@boardProps()} />
            <div className="columns large-3 end callout panel radius">
              <div className="row">
                <DisplayPiece {...@nextPieceProps()} />
              </div>
              <div className="row">
                <DisplayPiece {...@queuePieceProps()} />
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

  nextPieceProps: ->
    pieceType: @state.nextPieceType
    cellClass: 'next-cell'
    id: "next-piece-container"
    pieceTitle: 'Next Piece'
    isDisabled: !@state.hasGameBegun
    containerClass: 'columns large-11 large-centered'

  queuePieceProps: ->
    pieceType: @state.queuePieceType
    cellClass: 'queue-cell'
    id: 'queue-piece-container'
    pieceTitle: 'Queued Piece'
    isDisabled: !@state.canQueuePiece || !@state.shouldAllowQueue
    containerClass: 'columns large-11 large-centered'

  boardProps: ->
    cells: @state.cells
    cellEdgeLength: Calculate.cellEdgeLength(@state.boardDisplaySize)
    currentPieceType: @state.currentPieceType
    ghostYIndex: @state.ghostYIndex
    hasGameBegun: @state.hasGameBegun
    isGameOver: @state.isGameOver
    isGhostVisible: @state.isGhostVisible
    isPaused: @state.isPaused
    restartGame: @restartGame
    rotation: @state.rotation
    score: @state.score
    startGame: @startGame
    xIndex: @state.xIndex
    yIndex: @state.yIndex

  legendProps: ->
    level: Store.level()
    linesCleared: @state.linesCleared
    score: @state.score
    scoreThisTurn: @state.scoreThisTurn

  settingsProps: ->
    toggleQueue: Action.toggleQueue
    toggleGhost: Action.toggleGhost
    toggleMute: AudioAction.toggleMute
    shouldAllowQueue: @state.shouldAllowQueue
    isMuted: @state.isMuted
    isGhostVisible: @state.isGhostVisible

module.exports = Game
