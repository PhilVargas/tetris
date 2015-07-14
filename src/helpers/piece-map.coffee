PieceMap =
  I:
    color: 'turquoise'
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
    color: 'yellow'
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
    color: 'red'
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
    color: 'lime'
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
    color: 'orange'
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
    color: 'blue'
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
    color: 'purple'
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
