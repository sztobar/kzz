# module = angular.module('kzz.loginService', [])

# class LoginService
#   constructor: (@$state, @$http, @$q, @config) ->

#   login: (data) ->
#     defer = @$q.defer()
#     @$http(
#       method: 'POST'
#       data: data
#       url: config.url + '/login'
#     )
#     .success((data) ->
#       if data.success
#         @setUser(data.success.user)
#         defer.resolve(data.success.user)
#       else
#         defer.reject(data)
#     )
#     .error((data) ->
#       defer.reject(data)
#     )
#     return defer.promise


# module.service('LoginService', LoginService)
angular.module('kzz.loginService', [])

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