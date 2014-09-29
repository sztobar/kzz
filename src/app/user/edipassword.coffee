angular
.module('kzz.edituserpassword', [
])

.config(($stateProvider) ->
  $stateProvider
  .state('edituser.editpassword',
    url: '/editpassword',
    views:
      'edituser@edituser':
        controller: 'EditPasswordCtrl',
        templateUrl: 'user/editpassword.html'
  )
)

.controller('EditPasswordCtrl',
($scope, $http, $rootScope, loginManager, $state) ->

  $scope.warning = {}

  $scope.editUserPassword = (form) ->
    warning = $scope.warning

    if not form.newPassword.length > 6
      warning.newPassword = 'Hasło musi mieć przynajmniej 6 znaków'
    else if form.newPassword isnt form.repeatPassword
      warning.repeatPassword = 'Hasła muszą się zgadzać'
    else
      delete warning.repeatPassword

    if not _.isEmpty(warning)
      return
    user = {
      user: {
        id: $scope.user.id
        newPassword: form.newPassword
      }
    }
    $scope.loading = true
    $http({method: 'POST', url: './php/public/edituserpassword', data: user})
    .success((data) ->
      $scope.loading = false
      if data.success
        $scope.editSuccess = true
      else
        $scope.error(data.error)
    ).error(->
      $scope.loading = false
      $scope.error()
    )

)