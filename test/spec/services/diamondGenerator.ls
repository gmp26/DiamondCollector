'use strict'

describe 'Service: diamondGenerator', (_) ->

  # load the service's module
  beforeEach module 'DiamondCollectorApp'

  # instantiate service
  diamondGenerator = {}
  beforeEach inject (_diamondGenerator_) ->
    diamondGenerator := _diamondGenerator_

  it 'should do something', ->
    expect(!!diamondGenerator).toBe true
