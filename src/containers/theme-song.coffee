redux = require 'react-redux'

ThemeSong = require 'components/theme-song'

mapStateToProps = (state) ->
  isMuted: state.settings.isMuted
  isPaused: state.settings.isPaused
  hasGameBegun: state.game.hasGameBegun

Container = redux.connect(
  mapStateToProps
)(ThemeSong)

module.exports = Container

