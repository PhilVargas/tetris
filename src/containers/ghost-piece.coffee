redux = require 'react-redux'

Piece = require 'components/piece'

mapStateToProps = (state) ->
  cellClass: 'ghost-cell'
  cellEdgeLength: state.settings.boardDisplaySize
  containerClass: 'ghost-container'
  isVisible: state.settings.isGhostVisible && state.game.hasGameBegun
  isColorblindActive: state.settings.isColorblindActive
  pieceType: state.game.currentPieceType
  rotation: state.game.rotation
  xIndex: state.game.xIndex
  yIndex: state.game.ghostYIndex

Container = redux.connect(
  mapStateToProps,
)(Piece)

module.exports = Container



