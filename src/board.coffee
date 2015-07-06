React = require 'react'

Board = React.createClass
  displayName: 'Board'

  propTypes:
    width: React.PropTypes.number.isRequired
    height: React.PropTypes.number.isRequired
    hiddenHeight: React.PropTypes.number.isRequired

  getDefaultProps: ->
    width: 10
    height: 22
    hiddenHeight: 2

  render: ->
    <div className="board">
      { @generateRows() }
    </div>

  generateRows: ->
    for i in [0..22]
      <div key={ i } className="row collapse cell-container">
        { @generateCells() }
      </div>

  generateCells: ->
    for i in [0..10]
      <div key={ i } className="cell"></div>

module.exports = Board
