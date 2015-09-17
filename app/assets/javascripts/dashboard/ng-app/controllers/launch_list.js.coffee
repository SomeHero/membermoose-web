@LaunchListController = angular.module('dashboardApp').controller 'LaunchListController', [
  '$scope'
  'Plan'
  '$window'
  'Account'
  'user'
  'FileUploader'
  ($scope, Plan, window, Account, user, FileUploader) ->
    window.scope = $scope

    csrf_token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

    template_urls = [
      "dashboard/ng-app/templates/launchlist/upload_logo.html",
      "dashboard/ng-app/templates/launchlist/choose_subdomain.html",
      "dashboard/ng-app/templates/launchlist/create_plan.html",
      "dashboard/ng-app/templates/launchlist/connect_stripe.html",
      "dashboard/ng-app/templates/launchlist/pick_your_plan.html",
      "dashboard/ng-app/templates/launchlist/preview_your_site.html",
      "dashboard/ng-app/templates/launchlist/share_with_email.html"
    ]
    template_index = 0
    $scope.user = user
    $scope.content_template_url = template_urls[template_index]
    $scope.active_step = 1
    $scope.uploader = new FileUploader({
      url: '/dashboard/account/upload_logo'
      headers : {
        'X-CSRF-TOKEN': csrf_token
      }
    })

    $scope.isActiveStep = (step) ->
      if step == $scope.active_step
        return "active-step"

    $scope.uploadLogoClicked = () ->
      $scope.uploader.uploadAll()

      $scope.active_step = 1

      template_index = 0
      $scope.content_template_url = template_urls[template_index]

    $scope.chooseSubDomainClicked = () ->
      $scope.active_step = 1

      template_index = 1
      $scope.content_template_url = template_urls[template_index]

    $scope.createPlanClicked = () ->
      $scope.plan = new Plan()

      $scope.active_step = 2

      template_index = 2
      $scope.content_template_url = template_urls[template_index]

    $scope.connectStripeClicked = () ->
      $scope.active_step = 3

      template_index = 3
      $scope.content_template_url = template_urls[template_index]

    $scope.updateSubdomainClicked = (user, form) ->
      console.log "updating subdomain"

      if form.$valid
        user.update().then(
          (updated_user) ->
            $scope.$parent.success_message = "Your account was successfully updated."
            $scope.$parent.show_success_message = true

            console.log("subdomain updated")
          (http)  ->
            console.log("error updating subdomain")
            errors = http.data

            $scope.$parent.error_message = "Sorry, an unexpected error ocurred.  Please try again."
            $scope.$parent.show_error_message = true
        )

    $scope.pickYourPlanClicked = () ->
      $scope.active_step = 4

      template_index = 4
      $scope.content_template_url = template_urls[template_index]

    $scope.previewYourSiteClicked = () ->
      $scope.active_step = 4

      template_index = 5
      $scope.content_template_url = template_urls[template_index]

    $scope.createPlan = (plan, form) ->
      plan.create().then(
        (plan) ->
          console.log("plan created")
        (http)  ->
          console.log("error creating plan")
          errors = http.data
      )

    $scope.stripe_connect = () ->
      openUrl = "/users/auth/stripe_connect"
      window.$windowScope = $scope
      window.open(openUrl, "Authenticate Account", "width=500, height=500")

      true

    $scope.handlePopupAuthentication = (network, oauth_authentication) ->
      scope.$apply ->
        $scope.applyNetwork network, oauth_authentication

    $scope.applyNetwork = (network, account) ->
      console.log("stripe connected")

    return
]

LaunchListController.$inject = ['$scope', 'Plan', '$window', 'Account', 'user', 'FileUploader']
