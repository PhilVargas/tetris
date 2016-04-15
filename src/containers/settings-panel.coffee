redux = require 'react-redux'

Actions = require 'actions/settings'
Settings = require 'components/settings'

mapStateToProps = (state) ->
  state.settings

Container = redux.connect(
  mapStateToProps,
  Actions.creators
)(Settings)

module.exports = Container
