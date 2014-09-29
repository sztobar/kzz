angular
.module('kzz.register', [
])

.config(($stateProvider) ->
  $stateProvider
  .state('register',
    url: '/register',
    views:
      login:
        controller: 'RegisterCtrl',
        templateUrl: 'login/register.html'
    )
)


.controller('RegisterCtrl',
($scope,$http) ->

  $scope.warning = {}

  $scope.tryToRegister = (form) ->
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

    if not form.repeatPassword
      warning.repeatPassword = 'Nie wypełniłeś hasła'
    else if form.password isnt form.repeatPassword
      warning.repeatPassword = 'Hasła muszą się zgadzać'
    else
      delete warning.repeatPassword

    if form.notes and form.notes.length > 500
      warning.notes = 'Uwagi mogą mieć do 500 znaków'
    else
      delete warning.notes

    if not form.group
      warning.group = 'Nie wybrałeś grupy'
    else
      delete warning.group

    if not _.isEmpty(warning)
      return
    login = {
      login: {
        username: form.username
        password: form.password
        group: form.group
        anonymous: form.anonymous
        notes: form.notes || ''
      }
    }
    $scope.loading = true
    $http({method: 'POST', url: './php/public/register', data: login})
    .success((data) ->
      $scope.loading = false
      if data.success
        $scope.registerSuccess = true
      else
        $scope.error(data.error)
    ).error( ->
      $scope.loading = false
      $scope.error()
    )

)