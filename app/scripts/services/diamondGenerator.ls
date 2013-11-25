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
      1: [10, ["line", "line", "circle"]]
      2: [15, ["line", "circle", "circle"]]
      3: [20, ["circle", "circle", "circle"]]
    }

    # Stores the generated point coordinates
    points = []

    this.generate = (level) ->
      this.resetPoints!
      for type in levels[level][1]
        switch type
          case "line"
            this.makeLine!
          case "circle"
            this.makeCircle!
      this.makeNoise level
      return points

    this.getPoints = ->
      return points

    this.resetPoints = ->
      points := []

    /**
     * Make points on a line y = ax + b
     */
    this.makeLine = ->
      numPoints = 10

      a = this.getRandom -2.5 2.5
      b = this.getRandom!
      xused = []

      for i from 1 to numPoints
        y = 11
        x = 0
        while Math.abs(y) > 10 || xused.indexOf(x) != -1 # out of range or used
          x = this.getRandom!
          y = a*x + b
        xused.push x
        points.push [x, y]

    /**
     * Make points on a circle (x + a)^2 + (y + b)^2 = c^2
     * Offset of circle is (-a, -b), radius is c
     * Note we don't check whether x has been previously used because it's too
     * unlikely to worry about with non-integer values.
     */
    this.makeCircle = ->
      numPoints = 30

      a = this.getRandom -5 5
      b = this.getRandom -5 5
      c = this.getRandom 1 25 # radius between 1 and 5
      
      for i from 1 to numPoints
        y = 11
        x = 0
        while Math.abs(y) > 10 || c - (x + a)^2 < 0 # out of range or invalid x value
          x = this.getRandom!
          if c - (x + a)^2 >= 0
            y = Math.sqrt(c - (x + a)^2) - b

        sign = Math.round(Math.random())
        if sign then y = -y - (2 * b)

        points.push [x, y]

    this.makeNoise = (level) ->
      numPoints = levels[level][0]
      for i from 1 to numPoints
        x = this.getRandom!
        y = this.getRandom!
        points.push [x, y]

    /**
     * Generates a signed random number with the properties
     * rangemin <= Math.abs(number) <= rangemax
     * This allow random numbers in the range e.g. -10 to 2, 2 to 10.
     * getRandom() can only return a single continuous range e.g. -10 to 10. 
     */
    this.getRandomSigned = (rangemin, rangemax, integer) ->
      num = this.getRandom rangemin, rangemax, integer
      sign = Math.round(Math.random())
      if sign then num = -num
      return num

    /**
     * Generates a random number between rangemin and rangemax.
     * Optionally number may be forced to an integer value. 
     */
    this.getRandom = (rangemin, rangemax, integer) ->
      if rangemin >= rangemax # can't do this, not sensibly anyway
        throw "Error: trying to generate a random number in range where range minimum is greater than range maximum. Minimum should be less than maximum."
        return 0

      if typeof rangemin == 'undefined' then rangemin = -10
      if typeof rangemax == 'undefined' then rangemax = 10
      if typeof integer == 'undefined' then integer = false # default to returning float values

      num = Math.random()*(rangemax - rangemin) + rangemin

      if integer then num = Math.round(num)
      if num < rangemin then num = rangemin
      if num > rangemax then num = rangemax

      return num

    return this


