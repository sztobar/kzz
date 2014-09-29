# module = angular.module('kzz.loginController', [])

# class LoginController
#   constructor: (@$scope, @$http, @$state, @LoginService) ->
#     @loading = false

#   tryToLogin: (form) ->
#     data = {
#       login: {
#         username: form.username
#         password: form.password
#       }
#     }
#     @loading = true
#     @LoginService.login(data)
#     .finally(->
#       @loading = false
#     )


# module.controller('LoginController', LoginController)
angular.module('kzz.login', [])

.controller('LoginCtrl',
($scope, $http, loginManager, $state) ->

  $scope.loading = false

  $scope.calendarReady.promise.then( ->
    $http({ method: 'GET', url: './php/public/islogged' })
    .success((data) ->
      if data.success
        loginManager.setUser(data.success.user)
        $scope.user = loginManager.getUser()
        $scope.userDefinedCalendar(data.success.user.choices)
        $state.go('logged')
    )
  )

  $scope.tryToLogin = (form) ->
    data = {
      login: {
        username: form.username
        password: form.password
      }
    }
    $scope.loading = true
    $http({method: 'POST', url: './php/public/login', data: data})
    .success((data) ->
      $scope.loading = false
      if data.success
        loginManager.setUser(data.success.user)
        $scope.userDefinedCalendar(data.success.user.choices)
        $state.go('logged')
      else
        $scope.error(data.error)
    ).error((data) ->
      $scope.loading = false
      $scope.error()
    )

)