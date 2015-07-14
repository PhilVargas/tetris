React = require 'react'
Cell = require 'components/cell'
Piece = require 'components/piece'
Ghost = require 'components/ghost'
DisplayPiece = require 'components/display-piece'
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
    isGameOver: React.PropTypes.bool.isRequired
    isPaused: React.PropTypes.bool.isRequired
    isMuted: React.PropTypes.bool.isRequired

  getDefaultProps: ->
    cellEdgeLength: Settings.cellEdgeLength
    initialX: Settings.boardXOffset
    initialY: Settings.boardYOffest
    hiddenRows: Settings.hiddenRows
    width: Settings.boardWidth
    height: Settings.boardHeight

  getInitialState: ->
    turnCount: @props.turnCount
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

  # Render functions #
  componentDidMount: ->
    Store.bindChange @boardChanged
    AudioStore.bindChange @audioChanged
    $(document).on 'keyup', (e) ->
      Action.togglePause() if e.which == 32
    @startGame()

  startGame: ->
    nextTurn = =>
      delay = Math.max(Settings.minTurnDelay, Settings.initialTurnDelay - @state.turnCount)
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
    />

  generateGhost: ->
    <Ghost
      yIndex={ @state.ghostYIndex }
      xIndex={ @state.xIndex }
      initialX={ @props.initialX }
      initialY={ @props.initialY }
      pieceType={ @state.currentPieceType }
      rotation={ @state.rotation }
    />

  generateNextPiece: ->
    <DisplayPiece
      pieceType={ @state.nextPieceType }
      cellClass='next-cell'
      id="next-piece-container"
      pieceTitle='Next Piece'
      containerClass='columns large-10 large-centered'
    />

  generateQueuePiece: ->
    <DisplayPiece
      pieceType={ @state.queuePieceType }
      cellClass='queue-cell'
      id='queue-piece-container'
      pieceTitle='Queued Piece'
      isDisabled={ !@state.canQueuePiece }
      containerClass='columns large-10 large-centered'
    />

  render: ->
    <div className="board">
      <div className="row">
        <div className="large-8 columns large-centered">
          <div className="row">
            <div className="columns large-4">
              <div className='row' >{ "score: #{@state.score}" }</div>
              <div className='row' >Move with <pre className='code'>ASD</pre></div>
              <div className='row' >Drop with <pre className='code' >W</pre></div>
              <div className='row' >Rotate with <pre className='code'>E</pre> & <pre className='code'>Q</pre></div>
              <div className='row' ><pre className='code'>Space</pre> to pause</div>
              <div className='row' ><pre className='code'>Enter</pre> to queue a piece</div>
              <div className="row switch radius tiny">
                <div className="columns large-4">Music</div>
                <input id="mute-button" type="checkbox" checked={ !@state.isMuted  } onChange={ @handleAudioChange } />
                <label className='columns large-4 end' onClick={ @handleAudioChange }></label>
              </div>
            </div>
            <div id='pieces' className='columns large-5'>
              { @generateRows() }
              { @generatePiece() }
              { @generateGhost() }
            </div>
            <div className="columns large-3 end">
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

  handleAudioChange: ->
    AudioAction.toggleMute()

  generateRows: ->
    for i in [0...Settings.boardHeight]
      <div
        key={ i }
        className={ cx "row collapse cell-container", { invisible: i < @props.hiddenRows } }
      >
        { @generateCells(i) }
      </div>

  generateCells: (yCoord) ->
    for xCoord in [0...Settings.boardWidth]
      cell = @state.cells[yCoord*Settings.boardWidth+xCoord]
      <Cell key={ cell.id } xIndex={ cell.xIndex } yIndex={ cell.yIndex } isFrozen={ cell.isFrozen } color={ cell.color } />

module.exports = Board
