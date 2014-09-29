angular
.module('kzzApp', [
  'templates-app',
  'templates-common',
  'templates-jade_app',
  'templates-jade_common',
  'ui.router',
  'ui.bootstrap',
  'ui.calendar',
  'kzz.filters',
  'kzz.services',
  'kzz.directives',
  'kzz.controllers',
])

.config(($stateProvider) ->
  $stateProvider
  .state('login',
    url: '/login',
    views:
      login:
        controller: 'LoginCtrl',
        templateUrl: 'login/login.html'
    )
)

.config(($urlRouterProvider) ->
  $urlRouterProvider.otherwise('/login')
)

.constant('config', ->
  url: '../php/public'
)

.config(($tooltipProvider) ->
  $tooltipProvider.setTriggers({
    mouseenter: 'mouseleave',
    click: 'click',
    focus: 'blur',
    never: 'mouseleave'
  })
)

.controller('AppCtrl',
($scope, $rootScope, loginManager, $location) ->

  $scope.pageTitle = 'Kalendarz zarządzania zajęciami'
  $scope.menu = true

  $scope.error = (message = 'Wystąpił błąd z połączeniem.') ->
    $scope.errorBox = {
      type: 'danger'
      message: message
    }

  routesThatDontRequireAuth = ['/login']
  routesThatRequireAdmin = ['/register', '/userlist', '/edituser']

  routeClean = (route, routes) ->
    return _.find(routes, (noAuthRoute) ->
      return _.str.startsWith(route, noAuthRoute)
    )

  $rootScope.$on('$stateChangeStart', (ev, to, toParams, from, fromParams) ->
    if not routeClean($location.url(), routesThatDontRequireAuth) and not loginManager.isLoggedIn()
      $location.path('/login')
    else if routeClean($location.url(), routesThatRequireAdmin) and not loginManager.isAdmin()
      $location.path('/login')
  )

)