redux = require 'redux'
settingsReducer = require 'reducers/settings'

reducer = redux.combineReducers(
  settings: settingsReducer
)

store = redux.createStore(reducer)

module.exports = store
