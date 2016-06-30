class Dashboard::Users::PasswordsController < Devise::PasswordsController
  def create
    do |resource|
      session["account_id"] = resource.account.id
    end
  end

   def new
       super
   end

   def update
       super
   end
   def edit
       super
   end
end
