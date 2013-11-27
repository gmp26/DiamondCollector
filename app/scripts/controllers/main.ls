'use strict'

angular.module 'DiamondCollectorApp'
  .controller 'MainCtrl', <[$scope]> ++ ($scope) ->
    $scope.level = 1
    $scope.levelset = 1
    $scope.newLevel = ->
      $scope.resetPlots!
      $scope.levelset = $scope.level

    $scope.plots = []
    $scope.maxplots = 3

    $scope.numFound = 0

    isFinished = ->
      return $scope.plots.length >= $scope.maxplots
    $scope.finished = isFinished!

    $scope.graphType = "explicit"
    $scope.inputExplicit = true
    $scope.inputImplicit = false
    
    $scope.explicit = {
      type: 'explicit',
      fx: '2*x+1'
    }

    /**
     * Allows generation of equations in the form:
     *   ax^2 + bxy + cy^2 + dx + ey = f
     * To parse this we form a quadratic equation in y:
     *   cy^2 + y(bx + e) + (ax^2 + dx - f) = 0
     * Then feed into the quadratic solution:
     *   y = -b +/- sqrt(b^2 - 4ac) / 2a
     *   where a = c, b = (bx + e), c = (ax^2 + dx - f)
     */
    $scope.implicit = {
      type: 'implicit',
      a: 1,
      b: 0,
      c: 1,
      d: 0,
      e: 0,
      f: 2,
      eqstr: ''
    }

    /**
     * Listener to reset plots.
     */
    $scope.resetPlots = ->
      $scope.plots = []
      $scope.finished = isFinished!

    /**
     * Listener so the user can add new plots to the graph.
     */
    $scope.newPlot = ->
      if $scope.plots.length < $scope.maxplots
        tmp = _.clone($scope.plots) 
        switch $scope.graphType
          case "explicit"
            tmp.push(_.clone($scope.explicit))
          case "implicit"
            buildEqStr!
            tmp.push(_.clone($scope.implicit))
        $scope.plots = _.clone(tmp)
      $scope.finished = isFinished!

    /**
     * Build the equation string in $scope.implicit.
     */
    buildEqStr = ->
      eqstr = ''
      before = false

      appends = {
        a: 'x^2',
        b: 'xy',
        c: 'y^2',
        d: 'x',
        e: 'y'
      }

      _.each _.keys(appends), (key) ->
        v = parseFloat $scope.implicit[key]
        if Math.abs(v) > 0
          if before && v > 0
            eqstr := eqstr.concat('+')
          eqstr := eqstr.concat(v+appends[key])
          before := true

      f = parseFloat $scope.implicit['f']
      eqstr = eqstr.concat(' = '+f)

      $scope.implicit.eqstr = eqstr

    /**
     * Listen for changes to graphType and set input type accordingly.
     * I feel there should be a better way to do this. Problem is ngShow
     * requires true / false, and we probably need to support more than two
     * graph types.
     * @param n  New graph type
     * @param o  Old graph type
     */
    $scope.$watch 'graphType', (n, o) ->
      $scope.inputExplicit = false
      $scope.inputImplicit = false
      switch n
        case "explicit"
          $scope.inputExplicit = true
        case "implicit"
          $scope.inputImplicit = true
      return n
