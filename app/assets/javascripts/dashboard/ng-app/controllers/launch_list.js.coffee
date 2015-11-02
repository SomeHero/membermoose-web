@LaunchListController = angular.module('dashboardApp').controller 'LaunchListController', [
  '$scope'
  'Plan'
  '$window'
  'Account'
  '$timeout'
  'fileReader'
  'stripe'
  'Upload'
  'AccountServiceChannel'
  'PlansServiceChannel'
  '$http'
  ($scope, Plan, window, Account, $timeout, fileReader, stripe, Upload, AccountServiceChannel, PlansServiceChannel, $http) ->
    window.scope = $scope
    csrf_token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

    $scope.active_step = 1
    $scope.select_plan = 0
    $scope.plan = {}
    $scope.image = {
      tempImage: {}
  	}
    $scope.newPlanSection = 1
    upload_logo_modal = null
    setup_subdomain_modal = null
    create_plan_modal = null
    connect_stripe_modal = null
    upgrade_plan_modal = null

    $scope.project = {
      steps: {
        step1: $scope.user.account.hasUploadedLogo && $scope.user.account.hasSetupSubdomain,
        step2: $scope.user.account.hasCreatedPlan,
        step3: $scope.user.account.hasConnectedStripe,
        step4: $scope.user.account.hasUpgradedPlan
      }
    }
    $scope.setup_subdomain = {
      subdomain: $scope.user.account.subdomain
    }
    $scope.credit_card = {}

    $scope.isActiveStep = (step) ->
      if step == $scope.active_step
        return "active-step"

    $scope.get_logo = () ->
      if $scope.image.tempImage.url
        return $scope.image.tempImage.url
      else
        return $scope.user.account.logo.url

    $scope.uploadLogoClicked = () ->
      if !upload_logo_modal
        upload_logo_modal = $('[data-remodal-id=upload-logo-modal]').remodal($scope.options)

      upload_logo_modal.open();

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
        upload_logo_modal.close()

        return

      Upload.upload(
        url: 'dashboard/account/upload_logo'
        data:
          file: $scope.file).then ((response) ->
            $scope.user.account = response.data

            AccountServiceChannel.accountUpdated()

            upload_logo_modal.close()
      ), ((resp) ->
        console.log 'Error status: ' + resp.status
      ), (evt) ->
        progressPercentage = parseInt(100.0 * evt.loaded / evt.total)
        console.log 'progress: ' + progressPercentage + '% ' + evt.config.data.file.name

    $scope.chooseSubDomainClicked = () ->
      if !setup_subdomain_modal
        setup_subdomain_modal = $('[data-remodal-id=subdomain-modal]').remodal($scope.options)

      setup_subdomain_modal.open();

    $scope.updateSubdomainClicked = (form) ->
      console.log "updating subdomain"

      if form.$valid
        subdomain = $scope.setup_subdomain.subdomain

        $scope.loading.show_spinner = true
        params = {
            subdomain: $scope.setup_subdomain.subdomain
        }
        $http.post('/dashboard/account/' + $scope.user.id  + '/change_subdomain', params).then(
          (response) ->
            $scope.user.account = response.data
            $scope.loading.show_spinner = false
            $scope.form_submitted = false

            $scope.success_message = "Your successfully setup your subdomain."
            $scope.show_success_message = true
            $scope.clear_messages()

            AccountServiceChannel.accountUpdated()

            setup_subdomain_modal.close();

          (http)  ->
            $scope.loading.show_spinner = false

            $scope.error_message = http.statusText
            $scope.show_error_message = true
        )

    $scope.isActiveSection = (section) ->
      if section == $scope.newPlanSection
        return "active"

      return ""

    $scope.nextSection = (form) ->
      if form.$valid
        $scope.newPlanSection = $scope.newPlanSection + 1
        $scope.form_submitted = false
      else
        $scope.form_submitted = true

    $scope.createPlanClicked = () ->
      if !create_plan_modal
        create_plan_modal = $('[data-remodal-id=new-plan-modal]').remodal($scope.options)

      create_plan_modal.open();

    $scope.createPlan = (form) ->
      if form.$valid
        Plan.setUrl('/dashboard/plans')
        $scope.loading.show_spinner = true
        $scope.form_submitted = true

        new Plan({
          name: $scope.plan.name,
          description: $scope.plan.description,
          amount: $scope.plan.amount,
          billing_interval: 1,
          billing_cycle: $scope.plan.billing_cycle,
          free_trial_period: $scope.plan.free_trial_period,
          terms_and_conditions: $scope.plan.terms_and_conditions
        }).create().then(
          (response) ->
            #$scope.user.account = response.data

            $scope.loading.show_spinner = false
            $scope.newPlanSection = 1

            $scope.user.account.hasCreatedPlan = true
            AccountServiceChannel.accountUpdated()
            PlansServiceChannel.plansUpdated()

            create_plan_modal.close()
          (http)  ->
            console.log("error creating plan; we should show something")
            $scope.errors = http.data

            $scope.loading.show_spinner = false

            $scope.clear_messages()
        )
      else
        console.log "Failed to Create a Plan"

    $scope.connectStripeClicked = () ->
      if !connect_stripe_modal
        connect_stripe_modal = $('[data-remodal-id=stripe-modal]').remodal($scope.options)

      connect_stripe_modal.open();

    $scope.stripe_connect = () ->
      openUrl = "/users/auth/stripe_connect"
      window.$windowScope = $scope
      window.open(openUrl, "Authenticate Account", "width=500, height=500")

      true

    $scope.handlePopupAuthentication = () ->
      scope.$apply ->
        $scope.applyNetwork

    $scope.applyNetwork = () ->
      $scope.user.account.hasConnectedStripe = true
      AccountServiceChannel.accountUpdated()

      connect_stripe_modal.close()

    $scope.upgradePlanClicked = () ->
      if !upgrade_plan_modal
        upgrade_plan_modal = $('[data-remodal-id=upgrade-plan-modal]').remodal($scope.options)

      upgrade_plan_modal.open();

    $scope.upgradePlanSubmit = () ->
      console.log("upgrade plan")

      stripe.setPublishableKey("pk_test_5Km0uUASqaRvRu1JTx8Iiefx")
      stripe.card.createToken($scope.credit_card).then((token) ->
        console.log 'token created for card ending in ', token.card.last4
        params = {
          stripe_token: token
        }
        $http.post('/dashboard/account/' + $scope.user.id  + '/upgrade_plan', params).then(
          () ->
            $scope.loading.show_spinner = false
            $scope.form_submitted = false

            $scope.$parent.success_message = "Your successfully upgraded your plan. You're awesome."
            $scope.$parent.show_success_message = true
            $scope.clear_messages()

            upgrade_plan_modal.close();

          (http)  ->
            $scope.loading.show_spinner = false

            $scope.error_message = http.statusText
            $scope.show_error_message = true
        )
      )

    $scope.clear_messages = () ->
      $timeout(remove_messages, 4000);

    remove_messages = () ->
      $scope.$parent.show_success_message = false

    onAccountUpdated = () ->
      $scope.project.steps.step1 = $scope.user.account.hasUploadedLogo && $scope.user.account.hasSetupSubdomain
      $scope.project.steps.step2 = $scope.user.account.hasCreatedPlan
      $scope.project.steps.step3 = $scope.user.account.hasConnectedStripe
      $scope.project.steps.step4 = $scope.user.account.hasUpgradedPlan

    AccountServiceChannel.onAccountUpdated($scope, onAccountUpdated);

    return
]

LaunchListController.$inject = ['$scope', 'Plan', '$window', 'Account', '$timeout', 'fileReader', 'stripe', 'Upload', 'AccountServiceChannel', 'PlansServiceChannel', '$http']
