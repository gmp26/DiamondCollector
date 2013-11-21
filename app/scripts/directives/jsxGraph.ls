'use strict';

angular.module 'DiamondCollectorApp'
  .directive 'jsxGraph', [ ->
    template: '<div id="jsxbox" class="jxgbox" style="width:500px; height:500px;"></div>'
    restrict: 'A'
    link: (scope, element, attrs) ->
      board = JXG.JSXGraph.initBoard('jsxbox', {
        boundingbox: [-10, 10, 10, -10],
        axis:true,
        showCopyright: false
      })
      plots = []

      /**
       * Watch function to trigger redraw when the cartesian input
       * function is updated.
       */
      scope.$watch attrs.jsxGraph, (n, o) ->
        resetGraph!

        count = 0;
        _.each n, (p) ->
          switch p.type
            case "cartesian"
              plots.push(updatecartesian p, count)
            case "circle"
              plots.push(updatecircle p, count)
          count++

      /**
       * Processes the passed-in string so that JavaScript can understand
       * it as a maths function.
       */
      parsefx = (fx) ->
        p = false
        try
          p = Parser.parse(fx)
        return p

      updatecartesian = (p, count) ->
        fx = parsefx p.fx
        if fx
          try
            return board.create('functiongraph', [(v) -> return fx.evaluate({x:v})])
        return false

      updatecircle = (circle, count) ->
        try
          p_options = {
            fixed: true,
            visible: false
          }
          p1 = board.create('point', [parseFloat(circle.cx), parseFloat(circle.cy)], p_options)
          p2 = board.create('point', [parseFloat(circle.rx), parseFloat(circle.ry)], p_options)
          plots.push(p1, p2)
          return board.create('circle', [p1, p2])
        return false;

      /**
       * Clear all the objects currently on the graph.
       */
      resetGraph = ->
        _.each( plots, (obj) ->
          if obj
            try
              board.removeObject(obj)
        )
        plots := []
  ]
