angular.module('kzz.filters', [])

.filter('events', ->
  (items, languageShow, lectureShow) ->
    output = []
    for item in items
      if not languageShow and item.classId is 1
        item.className = ''
        continue
      else if not lectureShow and item.typeId is 2
        item.className = ''
        continue
      else
        output.push(item)

    return output
)