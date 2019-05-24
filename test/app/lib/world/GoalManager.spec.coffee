describe('GoalManager', ->
  GoalManager = require 'lib/world/GoalManager'

  killGoal = {name: 'Kill Guy', killThangs: ['Guy1', 'Guy2'], id: 'killguy'}
  saveGoal = {name: 'Save Guy', saveThangs: ['Guy1', 'Guy2'], id: 'saveguy'}
  getToLocGoal = {name: 'Go there', getToLocation: {target: 'Frying Pan', who: 'Potato'}, id: 'id'}
  keepFromLocGoal = {name: 'Go there', keepFromLocation: {target: 'Frying Pan', who: 'Potato'}, id: 'id'}
  leaveMapGoal = {name: 'Go away', leaveOffSide: {who: 'Yall'}, id: 'id'}
  stayMapGoal =  {name: 'Stay here', keepFromLeavingOffSide: {who: 'Yall'}, id: 'id'}
  getItemGoal = {name: 'Mine', getItem: {who: 'Grabby', itemID: 'Sandwich'}, id: 'id'}
  keepItemGoal = {name: 'Not Yours', keepFromGettingItem: {who: 'Grabby', itemID: 'Sandwich'}, id: 'id'}
  session = {
    set: ->
    get: -> {goalStates: {}}
  }
  additionalGoals = [{
    stage: 1,
    goals: [
      {name: 'Additional Kill Guy', killThangs: ['AdditionalKillGuy1', 'AdditionalKillGuy2'], id: 'additionalkillguy'},
      {name: 'Additional Save Guy', saveThangs: ['AdditionalSaveGuy1', 'AdditionalSaveGuy2'], id: 'additionalsaveguy'}
    ]
  }, {
    stage: 2,
    goals: [leaveMapGoal, stayMapGoal, getItemGoal, keepItemGoal]
  }, {
    stage: -1,
    goals: [killGoal]
  }]

#  beforeEach ->
#    session.save = ->
#    spyOn(session, 'save')

  it('handles kill goal', ->
    gm = new GoalManager()
    gm.setGoals([killGoal])
    gm.worldGenerationWillBegin()
    gm.submitWorldGenerationEvent('world:thang-died', {thang: {id: 'Guy1'}}, 10)
    gm.worldGenerationEnded()
    goalStates = gm.getGoalStates()
    expect(goalStates.killguy.status).toBe('incomplete')
    expect(goalStates.killguy.killed.Guy1).toBe(true)
    expect(goalStates.killguy.killed.Guy2).toBe(false)
    expect(goalStates.killguy.keyFrame).toBe(0)

    gm.submitWorldGenerationEvent('world:thang-died', {thang: {id: 'Guy2'}}, 20)
    goalStates = gm.getGoalStates()
    expect(goalStates.killguy.status).toBe('success')
    expect(goalStates.killguy.killed.Guy1).toBe(true)
    expect(goalStates.killguy.killed.Guy2).toBe(true)
    expect(goalStates.killguy.keyFrame).toBe(20)
  )

  it('handles save goal', ->
    gm = new GoalManager()
    gm.setGoals([saveGoal])
    gm.worldGenerationWillBegin()
    gm.submitWorldGenerationEvent('world:thang-died', {thang: {id: 'Guy1'}}, 10)
    gm.worldGenerationEnded()
    goalStates = gm.getGoalStates()
    expect(goalStates.saveguy.status).toBe('failure')
    expect(goalStates.saveguy.killed.Guy1).toBe(true)
    expect(goalStates.saveguy.killed.Guy2).toBe(false)
    expect(goalStates.saveguy.keyFrame).toBe(10)

    gm = new GoalManager()
    gm.setGoals([saveGoal])
    gm.worldGenerationWillBegin()
    gm.worldGenerationEnded()
    goalStates = gm.getGoalStates()
    expect(goalStates.saveguy.status).toBe('success')
    expect(goalStates.saveguy.killed.Guy1).toBe(false)
    expect(goalStates.saveguy.killed.Guy2).toBe(false)
    expect(goalStates.saveguy.keyFrame).toBe('end')
  )

  it 'adds new additional goals without affecting old goals', =>
    gm = new GoalManager()
    gm.setGoals([killGoal])
    gm.worldGenerationWillBegin()
    gm.submitWorldGenerationEvent('world:thang-died', {thang: {id: 'Guy1'}}, 10)
    gm.submitWorldGenerationEvent('world:thang-died', {thang: {id: 'Guy2'}}, 20)
    gm.worldGenerationEnded()

    goalStates = gm.getGoalStates()
    expect(goalStates.killguy.status).toBe('success')
    expect(goalStates.killguy.killed.Guy1).toBe(true)
    expect(goalStates.killguy.killed.Guy2).toBe(true)
    expect(goalStates.killguy.keyFrame).toBe(20)

    gm.addAdditionalGoals(session, additionalGoals)
    goalStates = gm.getGoalStates()
    expect(goalStates.additionalkillguy.status).toBe('incomplete')
    expect(goalStates.additionalkillguy.killed).toBe(undefined)
    expect(goalStates.additionalkillguy.keyFrame).toBe(0)

    gm.worldGenerationWillBegin()
    gm.submitWorldGenerationEvent('world:thang-died', {thang: {id: 'AdditionalKillGuy1'}}, 30)
    gm.submitWorldGenerationEvent('world:thang-died', {thang: {id: 'AdditionalKillGuy2'}}, 40)
    gm.worldGenerationEnded()
    goalStates = gm.getGoalStates()

    expect(goalStates.additionalkillguy.status).toBe('success')
    expect(goalStates.additionalkillguy.killed.AdditionalKillGuy1).toBe(true)
    expect(goalStates.additionalkillguy.killed.AdditionalKillGuy2).toBe(true)
    expect(goalStates.additionalkillguy.keyFrame).toBe(40)
    expect(goalStates.additionalsaveguy.status).toBe('success')
    expect(goalStates.additionalsaveguy.killed.AdditionalSaveGuy1).toBe(false)
    expect(goalStates.additionalsaveguy.killed.AdditionalSaveGuy2).toBe(false)
    expect(goalStates.additionalsaveguy.keyFrame).toBe('end')

#  it 'adds all additionalGoals for the next stage', ->
#    expect(false).toBe(true)
#
#  it 'does not add additionalGoals when they don\'t match the stage', ->
#    expect(false).toBe(true)
#
#  it 'keeps the previously completed goals when additionalGoals are added', ->
#    expect(false).toBe(true)
#
#  it 'reports that all goals are complete when additionalGoals have been completed', ->
#    expect(false).toBe(true)
#
#  it 'reports that not all goals are complete when there are additionalGoals still left', ->
#    expect(false).toBe(true)

  xit 'handles getToLocation', ->
    gm = new GoalManager()
    gm.setGoals([getToLocGoal])
    gm.worldGenerationWillBegin()
    gm.worldGenerationEnded()
    goalStates = gm.getGoalStates()
    expect(goalStates.id.status).toBe('incomplete')
    expect(goalStates.id.arrived.Potato).toBe(false)
    expect(goalStates.id.keyFrame).toBe(0)

    gm = new GoalManager()
    gm.setGoals([getToLocGoal])
    gm.worldGenerationWillBegin()
    gm.submitWorldGenerationEvent('world:thang-touched-goal', {actor: {id: 'Potato'}, touched: {id: 'Frying Pan'}}, 10)
    gm.worldGenerationEnded()
    goalStates = gm.getGoalStates()
    expect(goalStates.id.status).toBe('success')
    expect(goalStates.id.arrived.Potato).toBe(true)
    expect(goalStates.id.keyFrame).toBe(10)

  xit 'handles keepFromLocation', ->
    gm = new GoalManager()
    gm.setGoals([keepFromLocGoal])
    gm.worldGenerationWillBegin()
    gm.submitWorldGenerationEvent('world:thang-touched-goal', {actor: {id: 'Potato'}, touched: {id: 'Frying Pan'}}, 10)
    gm.worldGenerationEnded()
    goalStates = gm.getGoalStates()
    expect(goalStates.id.status).toBe('failure')
    expect(goalStates.id.arrived.Potato).toBe(true)
    expect(goalStates.id.keyFrame).toBe(10)

    gm = new GoalManager()
    gm.setGoals([keepFromLocGoal])
    gm.worldGenerationWillBegin()
    gm.worldGenerationEnded()
    goalStates = gm.getGoalStates()
    expect(goalStates.id.status).toBe('success')
    expect(goalStates.id.arrived.Potato).toBe(false)
    expect(goalStates.id.keyFrame).toBe('end')

  xit 'handles leaveOffSide', ->
    gm = new GoalManager()
    gm.setGoals([leaveMapGoal])
    gm.worldGenerationWillBegin()
    gm.worldGenerationEnded()
    goalStates = gm.getGoalStates()
    expect(goalStates.id.status).toBe('incomplete')
    expect(goalStates.id.left.Yall).toBe(false)
    expect(goalStates.id.keyFrame).toBe(0)

    gm = new GoalManager()
    gm.setGoals([leaveMapGoal])
    gm.worldGenerationWillBegin()
    gm.submitWorldGenerationEvent('world:thang-left-map', {thang: {id: 'Yall'}}, 10)
    gm.worldGenerationEnded()
    goalStates = gm.getGoalStates()
    expect(goalStates.id.status).toBe('success')
    expect(goalStates.id.left.Yall).toBe(true)
    expect(goalStates.id.keyFrame).toBe(10)

  xit 'handles keepFromLeavingOffSide', ->
    gm = new GoalManager()
    gm.setGoals([stayMapGoal])
    gm.worldGenerationWillBegin()
    gm.submitWorldGenerationEvent('world:thang-left-map', {thang: {id: 'Yall'}}, 10)
    gm.worldGenerationEnded()
    goalStates = gm.getGoalStates()
    expect(goalStates.id.status).toBe('failure')
    expect(goalStates.id.left.Yall).toBe(true)
    expect(goalStates.id.keyFrame).toBe(10)

    gm = new GoalManager()
    gm.setGoals([stayMapGoal])
    gm.worldGenerationWillBegin()
    gm.worldGenerationEnded()
    goalStates = gm.getGoalStates()
    expect(goalStates.id.status).toBe('success')
    expect(goalStates.id.left.Yall).toBe(false)
    expect(goalStates.id.keyFrame).toBe('end')

  xit 'handles getItem', ->
    gm = new GoalManager()
    gm.setGoals([getItemGoal])
    gm.worldGenerationWillBegin()
    gm.worldGenerationEnded()
    goalStates = gm.getGoalStates()
    expect(goalStates.id.status).toBe('incomplete')
    expect(goalStates.id.collected.Grabby).toBe(false)
    expect(goalStates.id.keyFrame).toBe(0)

    gm = new GoalManager()
    gm.setGoals([getItemGoal])
    gm.worldGenerationWillBegin()
    gm.submitWorldGenerationEvent('world:thang-collected-item', {actor: {id: 'Grabby'}, item: {id: 'Sandwich'}}, 10)
    gm.worldGenerationEnded()
    goalStates = gm.getGoalStates()
    expect(goalStates.id.status).toBe('success')
    expect(goalStates.id.collected.Grabby).toBe(true)
    expect(goalStates.id.keyFrame).toBe(10)

  xit 'handles keepFromGettingItem', ->
    gm = new GoalManager()
    gm.setGoals([keepItemGoal])
    gm.worldGenerationWillBegin()
    gm.submitWorldGenerationEvent('world:thang-collected-item', {actor: {id: 'Grabby'}, item: {id: 'Sandwich'}}, 10)
    gm.worldGenerationEnded()
    goalStates = gm.getGoalStates()
    expect(goalStates.id.status).toBe('failure')
    expect(goalStates.id.collected.Grabby).toBe(true)
    expect(goalStates.id.keyFrame).toBe(10)

    gm = new GoalManager()
    gm.setGoals([keepItemGoal])
    gm.worldGenerationWillBegin()
    gm.worldGenerationEnded()
    goalStates = gm.getGoalStates()
    expect(goalStates.id.status).toBe('success')
    expect(goalStates.id.collected.Grabby).toBe(false)
    expect(goalStates.id.keyFrame).toBe('end'))
