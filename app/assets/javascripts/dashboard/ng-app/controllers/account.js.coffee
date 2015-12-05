@AccountController = angular.module('dashboardApp').controller 'AccountController', [
  '$scope'
  '$state'
  '$stateParams'
  'Account'
  'Card'
  '$window'
  '$timeout'
  'fileReader'
  'Upload'
  'AccountServiceChannel',
  '$http'
  'stripe'
  ($scope, $state, $stateParams, Account, Card, window, $timeout, fileReader, Upload, AccountServiceChannel, $http, stripe) ->
    init = () ->
      window.scope = $scope
      $scope.loading.show_spinner = false
      $scope.form_submitted = false
      $scope.image = {
        tempImage: {}
      }
      change_password_modal = null
      upload_logo_modal = null
      upgrade_account_modal = null
      add_credit_card_modal = null
      update_credit_card_modal = null
      delete_credit_card_modal = null
      current_modal = null
      $scope.selected_credit_card = null
      $scope.isLoading = true
      $scope.change_password = {}
      $scope.show_error_message = false
      $scope.error_message = ""
      $scope.active_step = 1
      $scope.init()

      $(document).on 'closed', '.remodal', (e) ->
        # Reason: 'confirmation', 'cancellation'
        if $state.current.name.indexOf("account") > -1
          $state.go('dashboard.account')


    $scope.updateAccount = (user, form) ->
      console.log "updating user"

      if form.$valid
        $scope.display_loading()
        user.update().then(
          (response) ->
            $scope.user = new Account(response.data)

            message = "Your account was successfully updated."
            $scope.display_success_message(message)

            $scope.dismiss_loading()

            AccountServiceChannel.accountUpdated()
          (http)  ->
            errors = http.data

            message = errors.message
            $scope.display_error_message(message)

            $scope.dismiss_loading()
        )

    $scope.get_logo = () ->
      if $scope.image.tempImage.url
        return $scope.image.tempImage.url
      else
        return $scope.user.account.logo.url

    $scope.upload_logo_clicked = () ->
      if !upload_logo_modal
        upload_logo_modal = $('[data-remodal-id=upload-logo-modal]').remodal($scope.options)

      upload_logo_modal.open();
      $scope.setCurrentModal(upload_logal_modal)

    $scope.submitLogo = () ->
      console.log("submit logo clicked")

      if !$scope.file
        $scope.dismissModal()

        return

      Upload.upload(
        url: 'dashboard/account/upload_logo'
        data:
          file: $scope.file).then ((response) ->
        $scope.setUser(response.data)
        AccountServiceChannel.accountUpdated()

        message = "You successfully uploaded your logo."
        $scope.display_success_message(message)

        $scope.dismissModal()

        return
      ), ((resp) ->
        message = resp.status
        $scope.display_error_message(message)

        return
      ), (evt) ->
        progressPercentage = parseInt(100.0 * evt.loaded / evt.total)
        console.log 'progress: ' + progressPercentage + '% ' + evt.config.data.file.name
        return

    $scope.upgrade_plan_clicked = () ->
      if !upgrade_plan_modal
        upgrade_plan_modal = $('[data-remodal-id=upgrade-plan-modal]').remodal($scope.options)

      upgrade_plan_modal.open()
      $scope.setCurrentModal(upgrade_plan_modal)

    $scope.changePasswordClicked = () ->
      if !change_password_modal
        change_password_modal = $('[data-remodal-id=change-password-modal]').remodal($scope.options)

      change_password_modal.open()
      $scope.setCurrentModal(change_password_modal)

    $scope.changePasswordCancelled = (form) ->
      $scope.dismissModal()

    $scope.updatePassword = (form) ->
      console.log "updating user"
      $scope.form_submitted = true

      if form.$valid
        $scope.display_loading()

        params = {
            current_password: $scope.change_password.current_password,
            new_password: $scope.change_password.new_password,
            new_password_again: $scope.change_password.new_password_again
        }
        $http.post('/dashboard/account/' + $scope.user.user_id  + '/change_password', params).then(
          () ->
            $scope.dismiss_loading()
            $scope.form_submitted = false

            message = "You successfully updated your password."
            $scope.display_success_message(message)

            $scope.change_password = {}

            $scope.dismissModal()

          (http)  ->
            $scope.dismiss_loading()

            message = http.statusText
            $scope.display_error_message(message)
        )

    $scope.addCreditCardClicked = () ->
      $scope.credit_card = {}
      $scope.credit_card_attr = {
        default: false
      }
      if !add_credit_card_modal
        add_credit_card_modal = $('[data-remodal-id=add-card-modal]').remodal($scope.options)

      add_credit_card_modal.open()
      $scope.setCurrentModal(add_credit_card_modal)

    $scope.addCreditCardSubmit = () ->
      stripe_key = $scope.getPublishableKey()

      stripe.setPublishableKey(stripe_key)

      $scope.display_loading()
      $scope.form_submitted = true

      stripe.card.createToken($scope.credit_card).then((token) ->
        new Card({
          card_brand: $scope.credit_card.card_brand,
          card_last4: $scope.credit_card.card_last4,
          exp_month: $scope.credit_card.exp_month,
          exp_year: $scope.credit_card.exp_year,
          stripe_token: token,
          default: $scope.credit_card_attr.default
        }).create().then(
          (response) ->
            new_card = new Card(response.data)
            $scope.user.account.cards.push(new_card)

            $scope.credit_card = {}

            $scope.dismiss_loading()
            $scope.form_submitted = false

            message = "Your credit card was successfully added. You're awesome."
            $scope.display_success_message(message)

            AccountServiceChannel.accountUpdated()

            $scope.dismissModal()

          (http)  ->
            $scope.dismiss_loading()

            message = http.statusText
            $scope.display_error_message(message)
        )
      ).catch (err) ->
        $scope.dismiss_loading()

        if err.type and /^Stripe/.test(err.type)
          console.log 'Stripe error: ', err.message
        else
          console.log 'Other error occurred, possibly with your API', err.message


    $scope.updateCreditCardClicked = () ->
      $scope.selected_credit_card = null
      $scope.credit_card = {}
      $scope.active_step = 1
      if !update_credit_card_modal
        update_credit_card_modal = $('[data-remodal-id=update-card-modal]').remodal($scope.options)

      update_credit_card_modal.open();
      $scope.setCurrentModal(update_credit_card_modal)

    $scope.updateCreditCardSubmit = () ->
      stripe_key = $scope.getPublishableKey()

      stripe.setPublishableKey(stripe_key)

      scope.display_loading()

      Card.setUrl('/dashboard/cards')
      stripe.card.createToken($scope.credit_card).then((token) ->
        card = new Card({
          id: $scope.selected_credit_card.id,
          card_brand: $scope.credit_card.card_brand,
          card_last4: $scope.credit_card.card_last4,
          exp_month: $scope.credit_card.exp_month,
          exp_year: $scope.credit_card.exp_year,
          stripe_token: token,
          default: $scope.credit_card_attr.default
        })
        card.update().then(
          (response) ->
            $scope.dismiss_loading()
            $scope.closeEditBar()

            message = "Your credit card ending in " + $scope.selected_credit_card.last4 + " was successfully updated."
            $scope.display_success_message(message)

            angular.forEach($scope.user.account.cards, (value,index) =>
              if value.id == $scope.selected_credit_card.id
                $scope.user.account.cards[index] = new Card(response.data)

                return
            )
            $scope.selected_credit_card = null

            $scope.dismissModal()
          (http)  ->
            $scope.dismiss_loading()

            errors = http.data

            message = errors
            $scope.display_error_message(message)
        )
      )

    $scope.deleteCreditCardClicked = () ->
      $scope.selected_credit_card = null
      $scope.active_step = 1

      if !delete_credit_card_modal
        delete_credit_card_modal = $('[data-remodal-id=delete-card-modal]').remodal($scope.options)

      delete_credit_card_modal.open();
      $scope.setCurrentModal(delete_credit_card_modal)

    $scope.deleteCreditCardSubmit = () ->
      $scope.display_loading()

      Card.setUrl('/dashboard/cards')
      card = new Card($scope.selected_credit_card)
      card.delete().then(
        (response) ->
          $scope.dismiss_loading()
          $scope.closeEditBar()

          message = "Your card, " + $scope.selected_credit_card.last4 + ", was successfully deleted."
          $scope.display_success_message(message)

          angular.forEach($scope.user.account.cards, (value,index) =>
            if value.id == $scope.selected_credit_card.id
              $scope.user.account.cards.splice(index, 1)
          )
          $scope.selected_credit_card = null

          $scope.dismissModal()
        (http)  ->
          $scope.dismiss_loading()

          errors = http.data

          message = errors
          $scope.display_error_message(message)
      )

    $scope.setActiveStep = (step) ->
      if step == $scope.active_step
        return "active"

    $scope.setSelectedCard = (card) ->
      $scope.selected_credit_card = card

    $scope.isSelectedCard = (card) ->
      if card == $scope.selected_credit_card
        return "selected"

    $scope.nextStep = () ->
      $scope.active_step += 1

    $scope.previousStep = () ->
      $scope.active_step -= 1

    init()

    return
]

AccountController.$inject = ['$scope', '$state', '$stateParams', 'Account', 'Card', 'window', '$timeout', 'fileReader', 'Upload', 'AccountServiceChannel', '$http', 'stripe']
