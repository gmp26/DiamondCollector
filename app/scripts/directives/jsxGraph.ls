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
       * Watch function to trigger redraw when the input equations are changed.
       */
      scope.$watch attrs.jsxGraph, (n, o) ->
        resetGraph!

        _.each n, (p) ->
          switch p.type
            case "explicit"
              updateexplicit p
            case "implicit"
              updateimplicit p

      /**
       * Processes the passed-in string so that JavaScript can understand
       * it as a maths function.
       */
      parsefx = (fx) ->
        p = false
        try
          p = Parser.parse(fx)
        return p

      calcquadratic = (x, p) ->
        a = parseFloat(p.a)
        b = parseFloat(p.b)
        c = parseFloat(p.c)
        d = parseFloat(p.d)
        e = parseFloat(p.e)
        f = 0 - parseFloat(p.f)
        rootpart = (b*x + e)^2 - 4*c*(a*x^2 + d*x + f)
        if rootpart >= 0
          points = []
          points.push((-(b*x + e) - Math.sqrt(rootpart)) / 2*c)
          points.push((-(b*x + e) + Math.sqrt(rootpart)) / 2*c)
          return points  
        return null

      updateexplicit = (p) ->
        fx = parsefx p.fx
        if fx
          try
            plots.push board.create('functiongraph', [(v) -> return fx.evaluate({x:v})])
            return true
        return false

      updateimplicit = (p) ->
        try
          px = []
          pnegy = []
          pposy = []
          for x from -10 to 10 by 0.001
            points = calcquadratic(x, p)
            if points !== null
              px.push(x)
              pnegy.push(points[0])
              pposy.push(points[1])
          plots.push board.create('curve', [px, pnegy])
          plots.push board.create('curve', [px, pposy])
          return true
        return false

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
