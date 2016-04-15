redux = require 'react-redux'

DisplayPiece = require 'components/display-piece'
assign = require 'object-assign'

mapStateToProps = (state, ownProps) ->
  isColorblindActive: state.settings.isColorblindActive
  isDisabled: !state.game.canQueuePiece || !state.settings.shouldAllowQueue
  cellClass: 'queue-cell'
  id: 'queue-piece-container'
  pieceTitle: 'Queued Piece'
  containerClass: 'columns large-11 large-centered'
  pieceType: state.game.queuePieceType
  canQueuePiece: state.game.canQueuePiece

Container = redux.connect(
  mapStateToProps,
)(DisplayPiece)

module.exports = Container


