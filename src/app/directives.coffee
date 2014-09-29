angular.module('kzz.directives', [])

.directive('kzzMeny', ->
  return {
    restrict: 'A'
    priority: 0
    link: ($scope, $elem, $attrs) ->
      menyConfig = {
        menuElement: document.querySelector('.meny')
        contentsElement: document.querySelector('.contents')
        position: 'left'
        width: 320
        threshold: 40
        transitionDuration: '0.5s'
        transitionEasing: 'ease'
        mouse: true
        touch: true
      }
      meny = Meny.create(menyConfig)
  }
)

.service('Overlay', ->
  class Overlay
    constructor: (@elem) ->
      @created = false
    create: ->
      @overlay = $('<div class="loading-overlay"><i class="fa fa-spinner fa-spin fa-5x"></i></div>')
      $parent = @elem.parent()
      $parent.css('position','relative')
      @overlay.height($parent.height())
      @overlay.width($parent.width())
      $parent.append(@overlay)
      @created = true
    recreate: ->
      @overlay.remove()
      @create()
    show: ->
      if not @created
        @create()
      @overlay.css('visibility', 'visible')
    hide: ->
      if not @created
        return
      @overlay.css('visibility', 'hidden')
    resize: ->
      if not @created
        @create()
      else
        @recreate()
)

.directive('loadingOverlay',
(Overlay) ->
  return {
    restrict: 'A'
    link: ($scope, $elem, $attrs, $model) ->
      overlay = new Overlay($elem)
      angular.element(window).on('resize', ->
        overlay.resize()
      )
      $scope.$watch($attrs.loadingOverlay, (newVal) ->
        if newVal is true
          overlay.show()
        else
          overlay.hide()
      )
  }
)

.directive('autoFillSync',
($timeout) ->
  return {
    require: 'ngModel',
    link: (scope, $elem, attrs, ngModel) ->
      origVal = $elem.val()
      $timeout( ->
        newVal = $elem.val()
        if ngModel.$pristine and origVal isnt newVal
          ngModel.$setViewValue(newVal)
      , 500)
    }
)
