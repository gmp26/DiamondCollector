/**
 * Generates co-ordinates for diamonds to be placed on the graph.
 * Strictly this doesn't need to be a service, but it's interesting to make it
 * as such in order to see how Angular services work.
 * TODO - review whether this should even be in a service :)
 */

'use strict';

angular.module('DiamondCollectorApp')
  .service 'Diamondgenerator', ->
    # AngularJS will instantiate a singleton by calling "new" on this function

    /*
     * Lookup table indicating what types of plots should be generated at each
     * level. The first number for each level is the number of noise points to
     * create.
     */
    levels = {
      1: [3, ["line", "line", "circle"]]
      2: [4, ["line", "circle", "circle"]]
      3: [5, ["circle", "circle", "circle"]]
    }

    # Stores the generated point coordinates
    points = []

    this.generate = (level) ->
      this.resetPoints!
      for type in levels[level][1]
        switch type
          case "line"
            this.makeLine!
      this.makeNoise level
      return points

    this.resetPoints = ->
      points = []

    /**
     * Make points on a line y = ax + b
     */
    this.makeLine = ->
      numPoints = 5

      a = this.getRandomSigned 2.5 false
      b = this.getRandomSigned!
      xused = []

      for i from 1 to numPoints
        y = 11
        x = 0
        while Math.abs(y) > 10 || xused.indexOf(x) != -1 # out of range or used
          x = this.getRandomSigned 10 false
          y = a*x + b
        xused.push x
        points.push [x, y]

    this.makeCircle = ->
      return [0. 0]

    this.makeNoise = (level) ->
      numPoints = levels[level][0]
      for i from 1 to numPoints
        x = this.getRandomSigned!
        y = this.getRandomSigned!
        points.push [x, y]

    /**
     * Generates a random number in the between -range to range 
     */
    this.getRandomSigned = (range, integer) ->
      if typeof range == 'undefined' then range = 10 # default range -10 to 10
      if typeof integer == 'undefined' then integer = true # default to returning integers
      num = Math.random()*range
      if integer then num = Math.round(num)
      sign = Math.round(Math.random())
      if sign then num = -num
      return num

    return this


