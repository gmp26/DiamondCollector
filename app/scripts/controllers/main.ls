'use strict'

angular.module 'DiamondCollectorApp'
  .controller 'MainCtrl', <[$scope]> ++ ($scope) ->
    $scope.plots = []
    $scope.maxplots = 3

    isFinished = ->
      return $scope.plots.length >= $scope.maxplots
    $scope.finished = isFinished!

    $scope.graphType = "explicit"
    $scope.inputExplicit = true
    $scope.inputImplicit = false
    
    $scope.explicit = {
      type: 'explicit',
      fx: 'sin(x)'
    }
    
    $scope.implicit = {
      type: 'implicit',
      cx: '1',
      cy: '1',
      rx: '2',
      ry: '2'
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
            tmp.push(_.clone($scope.implicit))
        $scope.plots = _.clone(tmp)
      $scope.finished = isFinished!

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
