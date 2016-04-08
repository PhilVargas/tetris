redux = require 'react-redux'

Board = require 'components/board'

assign = require 'object-assign'

mapStateToProps = (state, ownProps) ->
  assign {}, state.game, ownProps,
    isPaused: state?.settings?.isPaused
    isGhostVisible: state?.settings?.isGhostVisible
    isMuted: state?.settings?.isMuted
    isColorblindActive: state?.settings?.isColorblindActive
    cellEdgeLength: state?.settings?.boardDisplaySize

Container = redux.connect(
  mapStateToProps
)(Board)

module.exports = Container

