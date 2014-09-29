angular
.module('kzz.userlist', [
])

.config(($stateProvider) ->
  $stateProvider
  .state('userlist',
    url: '/userlist',
    views:
      login:
        controller: 'UserlistCtrl',
        templateUrl: 'user/userlist.html'
  )
)

.controller('UserlistCtrl',
($scope, $http, $rootScope, loginManager, $state, $stateParams) ->

  $http({method: 'GET', url: './php/public/userlist'})
  .success((data) ->
    $scope.loading = false
    if data.success
      $scope.userlist = data.success.userlist
    else
      $scope.error(data.error)
  ).error(->
    $scope.loading = false
    $scope.error()
  )

)