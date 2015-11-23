@ChooseSubdomainController = angular.module('dashboardApp').controller 'ChooseSubdomainController', [
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
    init = () ->
      window.scope = $scope
      $scope.subdomain = "James"

      if !setup_subdomain_modal
        setup_subdomain_modal = $('[data-remodal-id=subdomain-modal]').remodal($scope.options)

      setup_subdomain_modal.open();
      $scope.setCurrentModal(setup_subdomain_modal)

    $scope.updateSubdomainClicked = (form) ->
      console.log "updating subdomain"

      if form.$valid
        $scope.display_loading()

        subdomain = $scope.setup_subdomain.subdomain
        params = {
            subdomain: $scope.setup_subdomain.subdomain
        }
        $http.post('/dashboard/account/' + $scope.user.id  + '/change_subdomain', params).then(
          (response) ->
            $scope.setUser(response.data)
            $scope.form_submitted = false

            message = "You successfully setup your subdomain."
            $scope.display_success_message(message)

            AccountServiceChannel.accountUpdated()

            $scope.dismiss_loading()
          (http)  ->
            $scope.dismiss_loading()

            message = http.statusText
            $scope.display_error_message(message)
        )

    init()

]

ChooseSubdomainController.$inject = ['$scope', 'Plan', '$window', 'Account', '$timeout', 'fileReader', 'stripe', 'Upload', 'AccountServiceChannel', 'PlansServiceChannel', '$http']
