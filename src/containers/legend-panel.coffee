redux = require 'react-redux'

Legend = require 'components/legend'

mapStateToProps = (state) ->
  level: state.game.level
  score: state.game.score
  scoreThisTurn: state.game.scoreThisTurn

Container = redux.connect(
  mapStateToProps
)(Legend)

module.exports = Container

