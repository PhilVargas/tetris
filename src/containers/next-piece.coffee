redux = require 'react-redux'

DisplayPiece = require 'components/display-piece'
assign = require 'object-assign'

mapStateToProps = (state, ownProps) ->
  isColorblindActive: state.settings.isColorblindActive
  cellClass: 'next-cell'
  id: "next-piece-container"
  pieceTitle: 'Next Piece'
  containerClass: 'columns large-11 large-centered'
  pieceType: state.game.nextPieceType
  isDisabled: !state.game.hasGameBegun

Container = redux.connect(
  mapStateToProps,
)(DisplayPiece)

module.exports = Container

