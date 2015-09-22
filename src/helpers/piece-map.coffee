PieceMap =
  E:
    color: -> 'lightgrey'
  I:
    color: (isColorblindActive) ->
      if isColorblindActive then '#44AA99' else 'turquoise'
    displayPieceCoords: {top: -10, left: 0}
    shapes: [
      [
        { x: 0, y: 0 }
        { x: 0, y: 1 }
        { x: 0, y: 2 }
        { x: 0, y: -1 }
      ]
      [
        { x: -2, y: 2 }
        { x: -1, y: 2 }
        { x: 0, y: 2 }
        { x: 1, y: 2 }
      ]
      [
        { x: -1, y: 0 }
        { x: -1, y: 1 }
        { x: -1, y: 2 }
        { x: -1, y: -1 }
      ]
      [
        { x: -2, y: 1 }
        { x: -1, y: 1 }
        { x: 0, y: 1 }
        { x: 1, y: 1 }
      ]
    ]
  O:
    color: (isColorblindActive) ->
      if isColorblindActive then '#999933' else 'yellow'
    displayPieceCoords: {top: 10, left: 10}
    shapes: [
      [
        { x: 0, y: 0 }
        { x: -1, y: 0 }
        { x: -1, y: -1 }
        { x: 0, y: -1 }
      ]
      [
        { x: 0, y: 0 }
        { x: -1, y: 0 }
        { x: -1, y: -1 }
        { x: 0, y: -1 }
      ]
      [
        { x: 0, y: 0 }
        { x: -1, y: 0 }
        { x: -1, y: -1 }
        { x: 0, y: -1 }
      ]
      [
        { x: 0, y: 0 }
        { x: -1, y: 0 }
        { x: -1, y: -1 }
        { x: 0, y: -1 }
      ]
    ]
  Z:
    color: (isColorblindActive) ->
      if isColorblindActive then '#882255' else 'red'
    displayPieceCoords: {top: 10, left: 0}
    shapes: [
      [
        { x: 0, y: 0 }
        { x: 1, y: 0 }
        { x: 0, y: -1 }
        { x: -1, y: -1 }
      ]
      [
        { x: 0, y: 0 }
        { x: 0, y: 1 }
        { x: 1, y: 0 }
        { x: 1, y: -1 }
      ]
      [
        { x: 0, y: 0 }
        { x: -1, y: 0 }
        { x: 0, y: 1 }
        { x: 1, y: 1 }
      ]
      [
        { x: 0, y: 0 }
        { x: 0, y: -1 }
        { x: -1, y: 0 }
        { x: -1, y: 1 }
      ]
    ]
  S:
    color: (isColorblindActive) ->
      if isColorblindActive then '#117733' else 'lime'
    displayPieceCoords: {top: 10, left: 0}
    shapes: [
      [
        { x: 0, y: 0 }
        { x: -1, y: 0 }
        { x: 0, y: -1 }
        { x: 1, y: -1 }
      ]
      [
        { x: 0, y: 0 }
        { x: 0, y: -1 }
        { x: 1, y: 0 }
        { x: 1, y: 1 }
      ]
      [
        { x: 0, y: 0 }
        { x: 1, y: 0 }
        { x: 0, y: 1 }
        { x: -1, y: 1 }
      ]
      [
        { x: 0, y: 0 }
        { x: 0, y: 1 }
        { x: -1, y: 0 }
        { x: -1, y: -1 }
      ]
    ]
  L:
    color: (isColorblindActive) ->
      if isColorblindActive then '#EE7722' else 'orange'
    displayPieceCoords: {top: 10, left: 0}
    shapes: [
      [
        { x: 0, y: 0 }
        { x: -1, y: 0 }
        { x: 1, y: 0 }
        { x: 1, y: -1 }
      ]
      [
        { x: 0, y: 0 }
        { x: 0, y: -1 }
        { x: 0, y: 1 }
        { x: 1, y: 1 }
      ]
      [
        { x: 0, y: 0 }
        { x: 1, y: 0 }
        { x: -1, y: 0 }
        { x: -1, y: 1 }
      ]
      [
        { x: 0, y: 0 }
        { x: 0, y: 1 }
        { x: 0, y: -1 }
        { x: -1, y: -1 }
      ]
    ]
  J:
    color: (isColorblindActive) ->
      if isColorblindActive then '#3366AA' else 'blue'
    displayPieceCoords: {top: 10, left: 0}
    shapes: [
      [
        { x: 0, y: 0 }
        { x: 1, y: 0 }
        { x: -1, y: 0 }
        { x: -1, y: -1 }
      ]
      [
        { x: 0, y: 0 }
        { x: 0, y: 1 }
        { x: 0, y: -1 }
        { x: 1, y: -1 }
      ]
      [
        { x: 0, y: 0 }
        { x: -1, y: 0 }
        { x: 1, y: 0 }
        { x: 1, y: 1 }
      ]
      [
        { x: 0, y: 0 }
        { x: 0, y: -1 }
        { x: 0, y: 1 }
        { x: -1, y: 1 }
      ]
    ]
  T:
    color: (isColorblindActive) ->
      if isColorblindActive then '#332288' else 'purple'
    displayPieceCoords: {top: 10, left: 0}
    shapes: [
      [
        { x: 0, y: 0 }
        { x: -1, y: 0 }
        { x: 0, y: -1 }
        { x: 1, y: 0 }
      ]
      [
        { x: 0, y: 0 }
        { x: 0, y: -1 }
        { x: 1, y: 0 }
        { x: 0, y: 1 }
      ]
      [
        { x: 0, y: 0 }
        { x: -1, y: 0 }
        { x: 1, y: 0 }
        { x: 0, y: 1 }
      ]
      [
        { x: 0, y: 0 }
        { x: -1, y: 0 }
        { x: 0, y: -1 }
        { x: 0, y: 1 }
      ]
    ]

module.exports = PieceMap
