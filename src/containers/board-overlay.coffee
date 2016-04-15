redux = require 'react-redux'

Overlay = require 'components/board-overlay'
assign = require 'object-assign'

mapStateToProps = (state, ownProps) ->
  assign {}, ownProps,
    isPaused: state.settings.isPaused
    isMuted: state.settings.isMuted
    hasGameBegun: state.game.hasGameBegun
    score: state.game.score
    isGameOver: state.game.isGameOver

Container = redux.connect(
  mapStateToProps,
)(Overlay)

module.exports = Container




