@LaunchListController = angular.module('dashboardApp').controller 'LaunchListController', [
  '$scope'
  'Plan'
  '$window'
  'Account'
  'FileUploader'
  '$timeout'
  ($scope, Plan, window, Account, FileUploader, timeout) ->
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
    $scope.content_template_url = template_urls[template_index]
    $scope.active_step = 1
    $scope.uploader = new FileUploader({
      url: '/dashboard/account/upload_logo'
      headers : {
        'X-CSRF-TOKEN': csrf_token
      }
    })
    $scope.select_plan = 0

    $scope.isActiveStep = (step) ->
      if step == $scope.active_step
        return "active-step"

    $scope.uploadLogoClicked = () ->
      options = {
        "hashTracking": false,
        "closeOnOutsideClick": false
      }
      inst = $('[data-remodal-id=upload-logo-modal]').remodal(options)
      inst.open();

    $scope.submitLogo = () ->
      $scope.uploader.onSuccessItem = (response, json) -> (
        $scope.user.account.logo = json["logo"]

        $scope.active_step = 1
        template_index = 1
        $scope.content_template_url = template_urls[template_index]
      )

      $scope.uploader.uploadAll()

    $scope.chooseSubDomainClicked = () ->
      options = {
        "hashTracking": false,
        "closeOnOutsideClick": false
      }
      inst = $('[data-remodal-id=subdomain-modal]').remodal(options)
      inst.open();

    $scope.updateSubdomainClicked = (user, form) ->
      console.log "updating subdomain"

      if form.$valid
        user.update().then(
          (updated_user) ->
            console.log("subdomain updated")

            $scope.active_step = 2

            template_index = 2
            $scope.content_template_url = template_urls[template_index]

          (http)  ->
            console.log("error updating subdomain")
            errors = http.data

            $scope.$parent.error_message = "Sorry, an unexpected error ocurred.  Please try again."
            $scope.$parent.show_error_message = true
            $scope.clear_message()
        )

    $scope.createPlanClicked = () ->
      console.log("create plan")

      options = {
        "hashTracking": false,
        "closeOnOutsideClick": false
      }
      inst = $('[data-remodal-id=new-plan-modal]').remodal(options)
      inst.open();

    $scope.createPlan = (plan, form) ->
      plan.create().then(
        (plan) ->
          console.log("plan created")

          $scope.active_step = 3

          template_index = 3
          $scope.content_template_url = template_urls[template_index]

        (http)  ->
          console.log("error creating plan")
          errors = http.data
      )

    $scope.connectStripeClicked = () ->
      options = {
        "hashTracking": false,
        "closeOnOutsideClick": false
      }
      inst = $('[data-remodal-id=stripe-modal]').remodal(options)
      inst.open();

    $scope.stripe_connect = () ->
      openUrl = "/users/auth/stripe_connect"
      window.$windowScope = $scope
      window.open(openUrl, "Authenticate Account", "width=500, height=500")

      true

    $scope.handlePopupAuthentication = (network, oauth_authentication) ->
      scope.$apply ->
        $scope.applyNetwork network, oauth_authentication

    $scope.applyNetwork = (network, account) ->
      $scope.active_step = 4

      template_index = 4
      $scope.content_template_url = template_urls[template_index]

      console.log("stripe connected")

    $scope.pickYourPlanClicked = () ->
      $scope.active_step = 4

      template_index = 4
      $scope.content_template_url = template_urls[template_index]

    $scope.isSelectedPlan = (plan_id) ->
      if plan_id == $scope.selected_plan
        "selected"

    $scope.setSelectedPlan = (plan_id) ->
      $scope.selected_plan = plan_id

    $scope.previewYourSiteClicked = () ->
      $scope.active_step = 4

      template_index = 5
      $scope.content_template_url = template_urls[template_index]

    $scope.clear_messages = () ->
      $timeout(remove_messages, 4000);

    remove_messages = () ->
      $scope.$parent.show_success_message = false

    return
]

LaunchListController.$inject = ['$scope', 'Plan', '$window', 'Account', 'FileUploader', '$timeout']
