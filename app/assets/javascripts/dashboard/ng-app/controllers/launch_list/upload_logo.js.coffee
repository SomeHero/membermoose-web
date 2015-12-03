@UploadLogoController = angular.module('dashboardApp').controller 'UploadLogoController', [
  '$scope'
  '$state'
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
  ($scope, $state, Plan, window, Account, $timeout, fileReader, stripe, Upload, AccountServiceChannel, PlansServiceChannel, $http) ->
    init = () ->
      window.scope = $scope

      $scope.fromLaunch = $state.current.data.fromLaunch

      if !upload_logo_modal
        upload_logo_modal = $('[data-remodal-id=upload-logo-modal]').remodal($scope.options)

      upload_logo_modal.open();
      $scope.setCurrentModal(upload_logo_modal)

    $scope.get_logo = () ->
      if $scope.image.tempImage.url
        return $scope.image.tempImage.url
      else
        return $scope.user.account.logo.url

    $scope.showLogo = () ->
      return $scope.user.account.logo.url.length > 0 || $scope.image.tempImage.url


    $scope.onFileSelect = ($files) ->
      $scope.file = $files[0]
      $scope.getFile()

    $scope.getFile = ->
      $scope.progress = 0
      fileReader.readAsDataUrl($scope.file, $scope).then ((result) ->
        $scope.image.tempImage.url = result
        $scope.image.tempImage.file_name = $scope.file
      ), (err) ->
        message = "Error uploading file"

    $scope.submitLogo = () ->
      if !$scope.file
        $scope.dismissModal()

        return

      $scope.display_loading()
      Upload.upload(
        url: 'dashboard/account/upload_logo'
        data:
          file: $scope.file).then ((response) ->
            $scope.setUser(response.data)

            $scope.dismiss_loading()

            message = "You successfully uploaded your logo."
            $scope.display_success_message(message)

            AccountServiceChannel.accountUpdated()

            if !$scope.fromLaunch
              $scope.dismissModal()

      ), ((resp) ->
        message = resp.status
        $scope.display_error_message(message)

        $scope.dismiss_loading()
      ), (evt) ->
        progressPercentage = parseInt(100.0 * evt.loaded / evt.total)
        console.log 'progress: ' + progressPercentage + '% ' + evt.config.data.file.name

    init()
]

UploadLogoController.$inject = ['$scope', '$state', 'Plan', '$window', 'Account', '$timeout', 'fileReader', 'stripe', 'Upload', 'AccountServiceChannel', 'PlansServiceChannel', '$http']
