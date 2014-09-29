angular
.module('kzz.logged', [
])

.config(($stateProvider) ->
  $stateProvider
  .state('logged',
    url: '/logged',
    views:
      login:
        controller: 'LoggedCtrl',
        templateUrl: 'login/logged.html'
    )
)


.controller('LoggedCtrl',
($scope,$http,$filter, loginManager, $rootScope) ->
  $scope.user = loginManager.getUser()

  $scope.logout = ->
    $scope.loading = true
    $http({method: 'GET', url: './php/public/logout'})
    .success((data) ->
      $scope.loading = false
      if data.error
        $scope.error(data.error)
      else
        $scope.resetUserCalendar()
        loginManager.logout()
    ).error( ->
      $scope.loading = false
      $scope.error()
    )

#  $scope.myEvents = []
#
#  unbind1 = $rootScope.$on('eventSelect', ($event, calendarEvent) ->
#    $scope.myEvents.push(calendarEvent)
#  )
#  $scope.$on('$destroy', unbind1)
#
#  unbind2 = $rootScope.$on('eventDeselect', ($event, calendarEvent) ->
#    myEvents = $scope.myEvents
#    for event, i in myEvents
#      if event is calendarEvent
#        myEvents.splice(i, 1)
#  )
#  $scope.$on('$destroy', unbind2)
#
#  $scope.deselect = (event) ->
#    $rootScope.$emit('calendarEventDeselect', event)
)
