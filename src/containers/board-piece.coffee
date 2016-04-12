redux = require 'react-redux'

Piece = require 'components/piece'

mapStateToProps = (state) ->
  cellClass: 'piece-cell'
  cellEdgeLength: state.settings.boardDisplaySize
  containerClass: 'piece-container'
  isVisible: state.game.hasGameBegun
  isColorblindActive: state.settings.isColorblindActive
  pieceType: state.game.currentPieceType
  rotation: state.game.rotation
  xIndex: state.game.xIndex
  yIndex: state.game.yIndex

Container = redux.connect(
  mapStateToProps,
)(Piece)

module.exports = Container


