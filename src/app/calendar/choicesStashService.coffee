angular.module('kzz.calendar')

.service('choicesStashService', ->

  service = this

  choicesStash = {}
  oneFromTwoStash = []
  twoFromThreeStash = {
    chosen: []
    omitted: []
  }


  
  #############################################################################
  service.choose = (event, events) ->
    if choicesStash[event.classId]
      choicesStash[event.classId].chosen.className = ''
      choicesStash[event.classId].omitted.className = ''
      delete choicesStash[event.classId]
      if (event.oneFromTwo)
        restoreOneFromTwo(event, events)
      else if (event.twoFromThree)
        restoreTwoFromThree(event, events)
    else
      twoClasses = false
      for item in events
        if item.classId is event.classId and item.eventId isnt event.eventId
          choicesStash[event.classId] = {
            chosen: event
            omitted: item
          }
          choicesStash[event.classId].chosen.className = 'chosen'
          choicesStash[event.classId].omitted.className = 'omitted'
          twoClasses = true
          break
      if not twoClasses
        choicesStash[event.classId] = {
          chosen: event
          omitted: {}
        }
        choicesStash[event.classId].chosen.className = 'chosen'
      if (event.oneFromTwo)
        omitOneFromTwo(event, events)
      else if (event.twoFromThree)
        omitTwoFromThree(event, events)
    return


  #############################################################################
  service.clear = ->
    for choice in choicesStash
      choice.chosen.className = ''
      choice.omitted.className = ''
    choicesStash = {}

    for omitted in oneFromTwoStash
      omitted.className = ''
    oneFromTwoStash.length = 0

    for choice in twoFromThreeStash
      for omitted in choice.omitted
        omitted.className = ''
    twoFromThreeStash.omitted.length = 0
    twoFromThreeStash.chosen.length = 0
    return


  #############################################################################
  omitOneFromTwo = (choice, events) ->
    for item in events
      if item.oneFromTwo and item.classId isnt choice.classId
        oneFromTwoStash.push(item)

    for omitted in oneFromTwoStash
      omitted.className = 'omitted'
    return



  #############################################################################
  restoreOneFromTwo = (choice, events) ->
    for omitted in oneFromTwoStash
      omitted.className = ''
    oneFromTwoStash.length = 0
    return


  #############################################################################
  omitTwoFromThree = (choice, events) ->
    if twoFromThreeStash.chosen.length is 0
      twoFromThreeStash.chosen.push(choice)

    else if twoFromThreeStash.chosen.length is 1
      twoFromThreeStash.chosen.push(choice)

      chosen = twoFromThreeStash.chosen
      chosenClassIds = [chosen[0].classId, chosen[1].classId]
      for item in events
        if item.twoFromThree and item.classId not in chosenClassIds
          twoFromThreeStash.omitted.push(item)

      for omitted in twoFromThreeStash.omitted
        omitted.className = 'omitted'
    return



  #############################################################################
  restoreTwoFromThree = (choice, events) ->
    if twoFromThreeStash.chosen.length is 1
      twoFromThreeStash.chosen.length = 0

    else if twoFromThreeStash.chosen.length is 2
      for chosen, i in twoFromThreeStash.chosen by -1
        if chosen.eventId is choice.eventId
          twoFromThreeStash.chosen.splice(i, 1)

      for omitted in twoFromThreeStash.omitted
        omitted.className = ''
      twoFromThreeStash.omitted.length = 0
    return

  return service

)