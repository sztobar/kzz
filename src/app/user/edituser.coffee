angular
.module('kzz.edituser', [
])

.config(($stateProvider) ->
  $stateProvider
  .state('edituser',
    url: '/edituser/:id',
    views:
      login:
        controller: 'EditUserCtrl',
        templateUrl: 'user/edituser-wrapper.html'
      'edituser@edituser':
        templateUrl: 'user/edituser.html'
  )
)

.controller('EditUserCtrl',
($scope, $http, $rootScope, loginManager, $state, $stateParams) ->


  data = {
    requestedUser: $stateParams.id
  }
  $scope.loading = true
  $http({method: 'POST', url: './php/public/edituser', data: data})
  .success((data) ->
    $scope.loading = false
    if data.success
      $scope.user = data.success.requestedUser
      $scope.fillCalendar(data.success.calendar)
      $scope.userDefinedCalendar(data.success.requestedUser.choices)
    else
      $scope.error(data.error)
  ).error(->
    $scope.loading = false
    $scope.error()
  )


  $scope.editSave = ->
    data = { events: [] }
    userId = $scope.user.id
    for event in $scope.myEvents
      data.events.push({
        events_id: event.eventId
        users_id: userId
      })
    data.userId = userId
    $scope.myEventsLoading = true
    $http({method: 'POST', url: './php/public/editsave', data: data})
    .success((data) ->
      $scope.myEventsLoading = false
      if data.error
        $scope.error(data.error)
      else
        $scope.fillCalendar(data.success.calendar)
        $scope.userDefinedCalendar(data.success.user.choices)
    ).error( ->
      $scope.myEventsLoading = false
    )


)