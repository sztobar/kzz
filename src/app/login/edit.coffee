angular
.module('kzz.edit', [
])

.config(($stateProvider) ->
  $stateProvider
  .state('edit',
    url: '/edit',
    views:
      login:
        controller: 'EditCtrl',
        templateUrl: 'login/edit.html'
  )
)

.controller('EditCtrl',
($scope, $http, $rootScope, loginManager, $state) ->

  $scope.warning = {}

  $scope.init = (form) ->
    if loginManager.isLoggedIn()
      user = loginManager.getUser()
      form.username = user.username
      form.notes = user.notes
      form.anonymous = user.anonymous

  $scope.tryToEdit = (form) ->
    warning = $scope.warning

    if not form.username
      warning.username = 'Nie wypełniłeś nazwy użytkownika'

    else if not form.username.match(/^[a-ząęółńćś]{2,}[\.]{1}[a-ząęółńćś]{2,}$/)
      warning.username = 'Nazwa użytkownika musi być w formie "imię.nazwisko" (tylko małe litery)'
    else
      delete warning.username

    if not form.password
      warning.password = 'Nie wypełniłeś hasła'
    else if not form.password.length > 6
      warning.password = 'Hasło musi mieć przynajmniej 6 znaków'
    else
      delete warning.password

    if not form.newPassword
      warning.newPassword = 'Nie wypełniłeś nowego hasła'
    else if not form.newPassword.length > 6
      warning.newPassword = 'Hasło musi mieć przynajmniej 6 znaków'
    else
      delete warning.newPassword

    if form.newPassword isnt form.repeatPassword
      warning.repeatPassword = 'Hasła muszą się zgadzać'
    else
      delete warning.repeatPassword

    if form.notes and form.notes.length > 500
      warning.notes = 'Uwagi mogą mieć do 500 znaków'
    else
      delete warning.notes

    if not _.isEmpty(warning)
      return
    login = {
      login: {
        username: form.username
        password: form.password
        newPassword: form.newPassword
        anonymous: form.anonymous
        notes: form.notes || ''
      }
    }
    $scope.loading = true
    $http({method: 'POST', url: './php/public/edit', data: login})
    .success((data) ->
      $scope.loading = false
      if data.success
        loginManager.setUser(data.success.user)
        $scope.fillCalendar(data.success.calendar)
        $scope.userDefinedCalendar(data.success.user.choices)
        $scope.editSuccess = true
      else
        $scope.error(data.error)
    ).error(->
      $scope.loading = false
      $scope.error()
    )

)