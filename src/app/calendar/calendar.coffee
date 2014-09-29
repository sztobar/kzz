angular.module('kzz.calendar', [])

.controller('CalendarCtrl',
($scope, $http, $rootScope, $filter, loginManager, $compile, $q, choicesStashService) ->

  eventSource = []
  choicesStash = {}
  dayNames = ["Niedziela", "Poniedziałek", "Wtorek", "Środa", "Czwartek", "Piątek"]

  $scope.eventSrc = [[]]
  $scope.eventsList = []
  $scope.languageShow = true
  $scope.lectureShow = true
  $scope.statisticsShow = true
  $scope.myEvents = []
  $scope.calendarReady = $q.defer()

  $scope.choose = (args) ->
    if not angular.isArray(args)
      event = args
      apply = true
      remote = true
    else
      event = args[0]
      apply = args[1] || true
      remote = args[2] || true
    if not loginManager.isLoggedIn() or !(loginManager.isAdmin() or remote)
      return
    if event.typeId is 2 or event.classId is 1
      event.className = if event.className is 'omitted' then '' else 'omitted'
      $scope.$apply() if apply
      return
    else if event.className is 'omitted' or
    _.isArray(event.className) and event.className[0] is 'omitted'
      return

    events = $scope.eventSrc[0]
    choicesStashService.choose(event, events)
    index = $scope.myEvents.indexOf(event)
    if index is -1
      $scope.myEvents.push(event)
    else
      $scope.myEvents.splice(index, 1)
    $scope.$apply() if apply and not $scope.$$phase

  # config object
  $scope.uiConfig = {
    calendar: {
      height: 1200
      header: false
      weekends: false
      editable: false
      columnFormat: { week: 'ddd' }
      timeFormat: { agenda: 'H:mm{ - H:mm}' }
      year: 2014
      month: 9
      date: 6
      allDaySlot: false
      axisFormat: 'H(:mm)'
      defaultEventMinutes: 90
      defaultView: 'agendaWeek'
      minTime: 7
      maxTime: 22
      dayNames: dayNames
      dayNamesShort: ["Ndz", "Pon", "Wt", "Śr", "Czw", "Pt"]
      eventClick: $scope.choose
      eventAfterRender: (event, element) ->
        container = element.find('.fc-event-inner')
        container.append('<div class="event-teacher">'+event.teacher+'</div>') if event.teacher
        container.append('<div class="event-room">'+event.room+'</div>') if event.room
        container.append('<div class="event-type">'+event.type+'</div>') if event.type
        if event.typeId isnt 2 and event.classId isnt 1
          dateObj = new Date(event.eventDate)
          if 1 <= dateObj.getDay() <= 3
            placement = 'right'
          else
            placement = 'left'
          htmlContent = '<div><strong>zapisanych osób: '+event.choices.length+'</strong></div><div>'
          for choice in event.choices
            if choice.users
              htmlContent += choice.users.username+', '
          htmlContent = htmlContent.slice(0, -2)+'</div>'
          element.attr('tooltip-placement', placement)
            .attr('tooltip-html-unsafe',htmlContent)
            .attr('tooltip-trigger','{{{true: "mouseenter", false: "never"}[statisticsShow]}}')
          $compile(element)($scope)
      eventTextColor: '#000'
    }
  }

  $http({method: 'GET', url: './php/public/calendar'})
  .success((data) ->
    if data.error
      $scope.error(data.error)
    else
      $scope.fillCalendar(data.success.calendar)
      $scope.eventsList = transformToList(data.success.calendar)
      $scope.calendarReady.resolve(true)
  ).error( ->
    $scope.error()
  )

  $scope.fillCalendar = (data) ->
    eventSource = []
    for event in data
      eventSource.push({
        title: event.classes.title
        start: event.date+' '+event.start
        end: event.date+' '+event.end
        eventDate: event.date
        allDay: false
        backgroundColor: event.classes.background
        room: event.room
        teacher: event.teacher
        type: event.classes.types.shortname
        classId: event.classes.id
        typeId: event.classes.types.id
        eventId: event.id
        choices: event.choices
        oneFromTwo: event.classes.oneFromTwo
        twoFromThree: event.classes.twoFromThree
      })
    choicesStashService.clear()
    $scope.eventSrc[0] = $filter('events')(eventSource, $scope.languageShow, $scope.lectureShow)

  $scope.userDefinedCalendar = (choices) ->
    $scope.resetUserCalendar()
    $scope.eventSrc[0] = $filter('events')(eventSource, $scope.languageShow, $scope.lectureShow)
    for choice in choices
      for event in $scope.eventSrc[0]
        if event.eventId is choice.events_id
          $scope.choose([event, false, true])
          break

  $scope.resetUserCalendar = ->
    choicesStashService.clear()
    $scope.myEvents = []



  $scope.$watch('languageShow', (newVal) ->
    $scope.eventSrc[0] = $filter('events')(eventSource, newVal, $scope.lectureShow)
  )
  $scope.$watch('lectureShow', (newVal) ->
    $scope.eventSrc[0] = $filter('events')(eventSource, $scope.languageShow, newVal)
  )

  $scope.save = ->
    $scope.myEventsLoading = true
    choices = []
    userId = loginManager.getUser().id
    for choice in $scope.myEvents
      choices.push({
        'events_id': choice.eventId
        'users_id': userId
      })

    $http({method: 'POST', url: './php/public/save', data: {events: choices}})
    .success((data) ->
      if data.error
        $scope.error(data.error)
      else
        $scope.fillCalendar(data.success.calendar)
        $scope.userDefinedCalendar(data.success.user.choices)
    )
    .finally(->
      $scope.myEventsLoading = false
    )
    # $scope.error("Wybieranie zajęć już zamknięte")


  transformToList = (events) ->
    list = []
    for event in events
      list.push({
        id: event.id
        type: event.classes.types.name
        name: event.classes.title
        room: event.room
        date: dayName(event.date)
        start: shortTime(event.start)
        end: shortTime(event.end)
        backgroundColor: event.classes.background
      })
    return list

  dayName = (dateString) ->
    dateObj = new Date(dateString)
    return dayNames[dateObj.getDay()]

  shortTime = (timeString) ->
    return timeString.substr(0, 5)



)
