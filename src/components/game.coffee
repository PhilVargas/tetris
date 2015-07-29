React = require 'react'
Cell = require 'components/cell'
Piece = require 'components/piece'
Ghost = require 'components/ghost'
Legend = require 'components/legend'
SettingsPanel = require 'components/settings'
DisplayPiece = require 'components/display-piece'
Overlay = require 'components/board-overlay'
Store = require 'stores/game'
Action = require 'actions/game'
AudioStore = require 'stores/audio'
AudioAction = require 'actions/audio'
Settings = require 'helpers/settings'
$ = require('jquery')
cx = require 'classnames'

Game = React.createClass
  displayName: 'Game'

  propTypes:
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

  # Render functions #
  componentDidMount: ->
    Store.bindChange @gameChanged
    AudioStore.bindChange @audioChanged

  startGame: ->
    unless @state.hasGameBegun
      Action.startGame()
      $(document).on 'keyup', (e) ->
        Action.togglePause() if e.which == 32
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

  pieceProps: ->
    yIndex: @state.yIndex
    xIndex: @state.xIndex
    pieceType: @state.currentPieceType
    setIndeces: Action.setPieceIndeces
    rotateClockwise: Action.rotateClockwise
    dropPiece: Action.dropPiece
    queuePiece: Action.queuePiece
    rotateCounterClockwise: Action.rotateCounterClockwise
    rotation: @state.rotation
    isPaused: @state.isPaused
    hasGameBegun: @state.hasGameBegun

  ghostProps: ->
    yIndex: @state.ghostYIndex
    xIndex: @state.xIndex
    pieceType: @state.currentPieceType
    rotation: @state.rotation
    isVisible: @state.isGhostVisible && @state.hasGameBegun

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

  render: ->
    <div className="game">
      <div className="row">
        <div className="large-11 columns large-centered">
          <div className="row">
            <div className="columns large-3">
              <Legend {...@legendProps()} />
              <SettingsPanel {...@settingsProps()} />
            </div>
            <div id='pieces' className='columns large-6'>
              <div className='row board-pieces-container'>
                <div className='columns inner-board-pieces-container' style={ @innerBoardStyles }>
                <div id='board-rows'>
                  { @generateRows() }
                </div>
                <Piece {...@pieceProps()} />
                <Ghost {...@ghostProps()} />
                <Overlay {...@overlayProps()} />
                </div>
              </div>
            </div>
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

  overlayProps: ->
    isPaused: @state.isPaused
    hasGameBegun: @state.hasGameBegun
    startGame: @startGame
    restartGame: @restartGame
    score: @state.score
    isGameOver: @state.isGameOver

  legendProps: ->
    level: Store.level()
    linesCleared: @state.linesCleared
    score: @state.score
    scoreThisTurn: @state.scoreThisTurn

  innerBoardStyles:
    width: Settings.cellEdgeLength * Settings.boardWidth + 2*Settings.innerBoardBorderWidth
    border: "#{Settings.innerBoardBorderWidth}px solid black"

  settingsProps: ->
    toggleQueue: Action.toggleQueue
    toggleGhost: Action.toggleGhost
    toggleMute: AudioAction.toggleMute
    shouldAllowQueue: @state.shouldAllowQueue
    isMuted: @state.isMuted
    isGhostVisible: @state.isGhostVisible

  generateRows: ->
    for i in [0...Settings.boardHeight]
      <div
        key={ i }
        className={ cx "row collapse cell-container", { 'hidden-row': i < Settings.hiddenRows } }
      >
        { @generateCells(i) }
      </div>

  generateCells: (yCoord) ->
    for xCoord in [0...Settings.boardWidth]
      cell = @state.cells[yCoord*Settings.boardWidth+xCoord]
      <Cell key={ cell.id } xIndex={ cell.xIndex } yIndex={ cell.yIndex } isFrozen={ cell.isFrozen } color={ cell.color } />

module.exports = Game
