@AccountController = angular.module('dashboardApp').controller 'AccountController', [
  '$scope'
  'Account'
  '$stateParams'
  '$window'
  '$timeout'
  'fileReader'
  'Upload'
  'AccountServiceChannel'
  ($scope, Account, $stateParams, window, $timeout, fileReader, Upload, AccountServiceChannel) ->

    $scope.image = {
      tempImage: {}
    }
    options = {
      "hashTracking": false,
      "closeOnOutsideClick": false
    }
    upload_logo_modal = null
    upgrade_account_modal = null

    $scope.getAccount = () ->
      Account.get($stateParams.id).then (result) ->
        $scope.user = result.data

    $scope.updateAccount = (user, form) ->
      console.log "updating user"

      if form.$valid
        user.update().then(
          (updated_user) ->
            $scope.$parent.success_message = "Your account was successfully updated."
            $scope.$parent.show_success_message = true
            $scope.clear_messages()

            console.log("account updated")
          (http)  ->
            console.log("error updating account")
            errors = http.data

            $scope.$parent.error_message = "Sorry, an unexpected error ocurred.  Please try again."
            $scope.$parent.show_error_message = true
            $scope.clear_messages()
        )

    $scope.get_logo = () ->
      if $scope.image.tempImage.url
        return $scope.image.tempImage.url
      else
        return $scope.user.account.logo.url

    $scope.upload_logo_clicked = () ->
      if !upload_logo_modal
        upload_logo_modal = $('[data-remodal-id=upload-logo-modal]').remodal(options)

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
        window.modal.close()

        return

      Upload.upload(
        url: 'dashboard/account/upload_logo'
        data:
          file: $scope.file).then ((resp) ->
        console.log 'Success ' + resp.config.data.file.name + 'uploaded. Response: ' + resp.data

        $scope.getAccount()
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

    $scope.upgrade_plan_clicked = () ->
      if !upgrade_plan_modal
        upload_logo_modal = $('[data-remodal-id=upgrade-plan-modal]').remodal(options)

      upgrade_plan_modal.open();

    $scope.clear_messages = () ->
      $timeout(remove_messages, 4000);

    remove_messages = () ->
      $scope.$parent.show_success_message = false

    $scope.getAccount()

    return
]

AccountController.$inject = ['$scope', 'Account', '$stateParams', 'window', '$timeout', 'fileReader', 'Upload', 'AccountServiceChannel']
