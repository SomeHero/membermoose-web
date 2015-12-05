class CreateUser
  def self.call(first_name, last_name, email_address, password, bull)

    user = User.find_by(email: email_address)

    if user
      account = user.accounts.where(:bull => bull).first

      #we should validate the users password
      return account if account
    end

    raw_token, enc_token = Devise.token_generator.generate(
      User, :reset_password_token)
    #password = SecureRandom.hex(32)

    if !user
      user = User.create!({
        email: email_address,
        password: password,
        password_confirmation: password,
        reset_password_token: enc_token,
        reset_password_sent_at: Time.now
      })
    end

    account = Account.create!({
      :user => user,
      :first_name => first_name,
      :last_name => last_name,
      :bull => bull
    })

    return account, raw_token
  end
end
