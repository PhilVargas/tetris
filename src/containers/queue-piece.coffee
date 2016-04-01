redux = require 'react-redux'

DisplayPiece = require 'components/display-piece'
assign = require 'object-assign'

mapStateToProps = (state, ownProps) ->
  assign {}, ownProps,
    isColorblindActive: state.settings.isColorblindActive
    #TODO: favor state over ownprops
    isDisabled: !ownProps.canQueuePiece || !state.settings.shouldAllowQueue
    cellClass: 'queue-cell'
    id: 'queue-piece-container'
    pieceTitle: 'Queued Piece'
    containerClass: 'columns large-11 large-centered'

Container = redux.connect(
  mapStateToProps,
)(DisplayPiece)

module.exports = Container


