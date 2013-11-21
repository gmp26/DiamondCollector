'use strict'

angular.module 'DiamondCollectorApp'
  .controller 'MainCtrl', <[$scope]> ++ ($scope) ->
    $scope.plots = []
    $scope.maxplots = 3

    isFinished = ->
      return $scope.plots.length >= $scope.maxplots
    $scope.finished = isFinished!

    $scope.graphType = "cartesian"
    $scope.inputCartesian = true
    $scope.inputCircle = false
    
    $scope.cartesian = {
      type: 'cartesian',
      fx: 'sin(x)'
    }
    
    $scope.circle = {
      type: 'circle',
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
          case "cartesian"
            tmp.push(_.clone($scope.cartesian))
          case "circle"
            tmp.push(_.clone($scope.circle))
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
      $scope.inputCartesian = false
      $scope.inputCircle = false
      switch n
        case "line"
          $scope.inputCartesian = true
        case "circle"
          $scope.inputCircle = true
        default
          $scope.inputCartesian = true
      return n
