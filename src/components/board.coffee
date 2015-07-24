React = require 'react'
Cell = require 'components/cell'
Piece = require 'components/piece'
Ghost = require 'components/ghost'
Legend = require 'components/legend'
SettingsPanel = require 'components/settings'
DisplayPiece = require 'components/display-piece'
Overlay = require 'components/board-overlay'
Store = require 'stores/board'
Action = require 'actions/board'
AudioStore = require 'stores/audio'
AudioAction = require 'actions/audio'
Settings = require 'helpers/settings'
$ = require('jquery')
cx = require 'classnames'

Board = React.createClass
  displayName: 'Board'

  propTypes:
    width: React.PropTypes.number.isRequired
    height: React.PropTypes.number.isRequired
    cellEdgeLength: React.PropTypes.number.isRequired
    initialX: React.PropTypes.number.isRequired
    initialY: React.PropTypes.number.isRequired
    hiddenRows: React.PropTypes.number.isRequired
    turnCount: React.PropTypes.number.isRequired
    currentPieceType: React.PropTypes.string.isRequired
    nextPieceType: React.PropTypes.string.isRequired
    queuePieceType: React.PropTypes.string.isRequired
    cells: React.PropTypes.array.isRequired
    rotation: React.PropTypes.number.isRequired
    score: React.PropTypes.number.isRequired
    scoreThisTurn: React.PropTypes.number.isRequired
    isGameOver: React.PropTypes.bool.isRequired
    isPaused: React.PropTypes.bool.isRequired
    isMuted: React.PropTypes.bool.isRequired
    isGhostVisible: React.PropTypes.bool.isRequired
    shouldAllowQueue: React.PropTypes.bool.isRequired
    linesCleared: React.PropTypes.number.isRequired
    hasGameBegun: React.PropTypes.bool.isRequired

  getDefaultProps: ->
    cellEdgeLength: Settings.cellEdgeLength
    initialX: Settings.boardXOffset
    initialY: Settings.boardYOffest
    hiddenRows: Settings.hiddenRows
    width: Settings.boardWidth
    height: Settings.boardHeight

  getInitialState: ->
    turnCount: @props.turnCount
    hasGameBegun: @props.hasGameBegun
    xIndex: @props.xIndex
    yIndex: @props.yIndex
    ghostYIndex: @props.ghostYIndex
    currentPieceType: @props.currentPieceType
    queuePieceType: @props.queuePieceType
    nextPieceType: @props.nextPieceType
    cells: @props.cells
    rotation: @props.rotation
    isGameOver: @props.isGameOver
    isPaused: @props.isPaused
    isMuted: @props.isMuted
    score: @props.score
    scoreThisTurn: @props.scoreThisTurn
    isGhostVisible: @props.isGhostVisible
    shouldAllowQueue: @props.shouldAllowQueue
    linesCleared: @props.linesCleared

  # Render functions #
  componentDidMount: ->
    Store.bindChange @boardChanged
    AudioStore.bindChange @audioChanged

  startGame: ->
    unless @state.hasGameBegun
      Action.startGame()
      $(document).on 'keyup', (e) ->
        Action.togglePause() if e.which == 32
    nextTurn = =>
      delay = Store.turnDelay()
      if @state.isGameOver
        alert('Game Over!')
      else
        Action.nextTurn()
        setTimeout(nextTurn, delay)
    setTimeout(nextTurn, Settings.initialTurnDelay)

  boardChanged: ->
    @setState Store.getAll()

  audioChanged: ->
    @setState AudioStore.getAll()

  componentWillUnmount: ->
    Store.unbindChange @boardChanged
    AudioStore.unbindChange @boardChanged
    $(document).off 'keyup'

  generatePiece: ->
    <Piece
      yIndex={ @state.yIndex }
      xIndex={ @state.xIndex }
      initialX={ @props.initialX }
      initialY={ @props.initialY }
      pieceType={ @state.currentPieceType }
      setIndeces={ Action.setPieceIndeces }
      rotateClockwise={ Action.rotateClockwise }
      dropPiece={ Action.dropPiece }
      queuePiece={ Action.queuePiece }
      rotateCounterClockwise={ Action.rotateCounterClockwise }
      rotation={ @state.rotation }
      isPaused={ @state.isPaused }
      hasGameBegun={ @state.hasGameBegun }
    />

  generateGhost: ->
    <Ghost
      yIndex={ @state.ghostYIndex }
      xIndex={ @state.xIndex }
      initialX={ @props.initialX }
      initialY={ @props.initialY }
      pieceType={ @state.currentPieceType }
      rotation={ @state.rotation }
      isVisible={ @state.isGhostVisible && @state.hasGameBegun}
    />

  generateNextPiece: ->
    <DisplayPiece
      pieceType={ @state.nextPieceType }
      cellClass='next-cell'
      id="next-piece-container"
      pieceTitle='Next Piece'
      isDisabled={ !@state.hasGameBegun }
      containerClass='columns large-11 large-centered'
    />

  generateQueuePiece: ->
    <DisplayPiece
      pieceType={ @state.queuePieceType }
      cellClass='queue-cell'
      id='queue-piece-container'
      pieceTitle='Queued Piece'
      isDisabled={ !@state.canQueuePiece || !@state.shouldAllowQueue }
      containerClass='columns large-11 large-centered'
    />

  render: ->
    <div className="board">
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
                { @generatePiece() }
                { @generateGhost() }
                <Overlay {...@overlayProps()} />
                </div>
              </div>
            </div>
            <div className="columns large-3 end callout panel radius">
              <div className="row">
                { @generateNextPiece() }
              </div>
              <div className="row">
                { @generateQueuePiece() }
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
        className={ cx "row collapse cell-container", { 'hidden-row': i < @props.hiddenRows } }
      >
        { @generateCells(i) }
      </div>

  generateCells: (yCoord) ->
    for xCoord in [0...Settings.boardWidth]
      cell = @state.cells[yCoord*Settings.boardWidth+xCoord]
      <Cell key={ cell.id } xIndex={ cell.xIndex } yIndex={ cell.yIndex } isFrozen={ cell.isFrozen } color={ cell.color } />

module.exports = Board
