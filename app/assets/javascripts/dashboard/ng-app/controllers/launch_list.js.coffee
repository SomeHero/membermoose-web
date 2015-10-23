@LaunchListController = angular.module('dashboardApp').controller 'LaunchListController', [
  '$scope'
  'Plan'
  '$window'
  'Account'
  '$timeout'
  'fileReader'
  'Upload'
  'AccountServiceChannel'
  ($scope, Plan, window, Account, timeout, fileReader, Upload, AccountServiceChannel) ->
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
    $scope.select_plan = 0
    $scope.image = {
      tempImage: {}
  	}
    $scope.isActiveStep = (step) ->
      if step == $scope.active_step
        return "active-step"

    $scope.get_logo = () ->
      if $scope.image.tempImage.url
        return $scope.image.tempImage.url
      else
        return $scope.user.account.logo.url

    $scope.uploadLogoClicked = () ->
      options = {
        "hashTracking": false,
        "closeOnOutsideClick": false
      }
      window.modal = $('[data-remodal-id=upload-logo-modal]').remodal(options)
      window.modal.open();

    	$scope.onFileSelect = ($files) ->

    		#$files: an array of files selected, each file has name, size, and type.
    		i = 0

    		while i < $files.length
    			$file = $files[i]
    			$scope.file = $file
    			$scope.getFile()

    			#upload.php script, node.js route, or servlet upload url
    			# method: POST or PUT,
    			# headers: {'headerKey': 'headerValue'}, withCredential: true,
    			i++

    	$scope.getFile = ->
    		$scope.progress = 0
    		fileReader.readAsDataUrl($scope.file, $scope).then (result) ->
    			$scope.image.tempImage.url = result
    			$scope.image.tempImage.file_name = $scope.file

    $scope.submitLogo = () ->
      console.log("submit logo clicked")

      if !$scope.file
        window.modal.close()

        return

      Upload.upload(
        url: 'dashboard/account/upload_logo'
        data:
          file: $scope.file).then ((resp) ->
        console.log 'Success ' + resp.config.data.file.name + 'uploaded. Response: ' + resp.data

        AccountServiceChannel.accountUpdated()

        window.modal.close()

        return
      ), ((resp) ->
        console.log 'Error status: ' + resp.status
        return
      ), (evt) ->
        progressPercentage = parseInt(100.0 * evt.loaded / evt.total)
        console.log 'progress: ' + progressPercentage + '% ' + evt.config.data.file.name
        return

    $scope.chooseSubDomainClicked = () ->
      options = {
        "hashTracking": false,
        "closeOnOutsideClick": false
      }
      window.modal = $('[data-remodal-id=subdomain-modal]').remodal(options)
      window.modal.open();

    $scope.updateSubdomainClicked = (form) ->
      console.log "updating subdomain"

      if form.$valid
        $scope.user.update().then(
          (updated_user) ->
            console.log("subdomain updated")

            window.modal.close()
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
      window.modal = $('[data-remodal-id=new-plan-modal]').remodal(options)
      window.modal.open();

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
        AccountServiceChannel.accountUpdated()

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

LaunchListController.$inject = ['$scope', 'Plan', '$window', 'Account', '$timeout', 'fileReader', 'Upload', 'AccountServiceChannel']
