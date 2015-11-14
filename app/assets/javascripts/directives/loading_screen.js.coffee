# Template directive to create loading ajax spinner
# As an argument, you can pass in a scope variable that it will evaluate.
# It will hide/show the ajax spinner based on the truthiness of the passed in var
#
# example:  <div loading-spinner=foo>
# Will hide/show the spinner based on if $scope.foo is true or false
(->
  loadingScreen = angular.module("loadingScreen", [])
  loadingScreen.directive "loadingScreen", ->
    restrict: 'EA'
    templateUrl: 'loading_screen.html'
    replace: true
    scope: true
    link: postLink = (scope, element, attrs) ->
      element.hide()
      background_color = element.css('background-color') #saves original bg color

      scope.$watch attrs.loadingScreen, ->
        if scope.$eval(attrs.loadingScreen)
          element.show()
        else
          element.hide()

        if scope.loading and scope.loading.hide_background
          element.css('background-color', 'transparent')
        else
          element.css('background-color', background_color)
      , true
)()
