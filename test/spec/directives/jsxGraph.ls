'use strict'

describe 'Directive: jsxGraph', (_) ->

  # load the directive's module
  beforeEach module 'DiamondCollectorApp'

  var $rootScope
  var $scope
  var $compile

  beforeEach inject (_$compile, _$rootScope) ->
    $rootScope := _$rootScope
    $scope := _$rootScope.$new!
    $compile := _$compile

  it 'should make hidden element visible', ->
    element = angular.element '<jsx-graph></jsx-graph>'
    element = $compile(element) $scope
    expect element.text! .toBe 'this is the jsxGraph directive'
