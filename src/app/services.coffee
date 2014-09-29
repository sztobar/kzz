angular.module('kzz.services', [
  'kzz.loginService'
])

.service('loginManager',
($state) ->
  user = false

  class LoginManager

    constructor: ->

    setUser: (data) ->
      user = data
      user.anonymous = Boolean(user.anonymous)

    getUser: ->
      return user

    isLoggedIn: ->
      return Boolean(user)

    isAdmin: ->
      return @isLoggedIn() && user.admin

    logout: ->
      user = false
      $state.go('login')

  loginManager = new LoginManager()
  return loginManager
)