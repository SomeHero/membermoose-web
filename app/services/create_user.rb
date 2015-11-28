class CreateUser
  def self.call(first_name, last_name, email_address, password, bull)

    user = User.find_by(email: email_address)

    return user.account if user.present?

    raw_token, enc_token = Devise.token_generator.generate(
      User, :reset_password_token)
    #password = SecureRandom.hex(32)

    account = Account.create!({
      :user => User.create!({
        email: email_address,
        password: password,
        password_confirmation: password,
        reset_password_token: enc_token,
        reset_password_sent_at: Time.now
      }),
      :first_name => first_name,
      :last_name => last_name,
      :bull => bull
    })

    return account, raw_token
  end
end
