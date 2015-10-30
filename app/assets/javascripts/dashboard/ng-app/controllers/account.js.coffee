@AccountController = angular.module('dashboardApp').controller 'AccountController', [
  '$scope'
  'Account'
  '$stateParams'
  '$window'
  '$timeout'
  'fileReader'
  'Upload'
  'AccountServiceChannel',
  '$http'
  ($scope, Account, $stateParams, window, $timeout, fileReader, Upload, AccountServiceChannel, $http) ->

    $scope.loading = {
      show_spinner: false
    }
    $scope.form_submitted = false
    $scope.image = {
      tempImage: {}
    }
    options = {
      "hashTracking": false,
      "closeOnOutsideClick": false
    }
    change_password_modal = null
    upload_logo_modal = null
    upgrade_account_modal = null
    $scope.isLoading = true
    $scope.change_password = {}
    $scope.show_error_message = false
    $scope.error_message = ""

    $scope.getAccount = () ->
      Account.get($stateParams.id).then (result) ->
        $scope.user = result.data

        $scope.isLoading = false

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

            $scope.parent.error_message = error.message
            $scope.$parent.show_error_message = true
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

    $scope.changePasswordClicked = () ->
      if !change_password_modal
        change_password_modal = $('[data-remodal-id=change-password-modal]').remodal(options)

      change_password_modal.open();

    $scope.changePasswordCancelled = (form) ->
      change_password_modal.close();

    $scope.updatePassword = (form) ->
      console.log "updating user"
      $scope.form_submitted = true

      if form.$valid
        $scope.loading.show_spinner = true
        params = {
            current_password: $scope.change_password.current_password,
            new_password: $scope.change_password.new_password,
            new_password_again: $scope.change_password.new_password_again
        }
        $http.post('/dashboard/account/' + $scope.user.user_id  + '/change_password', params).then(
          () ->
            $scope.loading.show_spinner = false
            $scope.form_submitted = false
            
            $scope.$parent.success_message = "Your account was successfully updated."
            $scope.$parent.show_success_message = true
            $scope.clear_messages()

            $scope.change_password = {}

            change_password_modal.close();

          (http)  ->
            $scope.loading.show_spinner = false

            $scope.error_message = http.statusText
            $scope.show_error_message = true
        )

    $scope.clear_messages = () ->
      $timeout(remove_messages, 4000);

    remove_messages = () ->
      $scope.$parent.show_success_message = false

    $scope.getAccount()

    return
]

AccountController.$inject = ['$scope', 'Account', '$stateParams', 'window', '$timeout', 'fileReader', 'Upload', 'AccountServiceChannel', '$http']
