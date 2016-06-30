class Dashboard::Users::PasswordsController < Devise::PasswordsController
  def after_database_authentication
    puts self
  end
   def create
     super
   end

   def new
       super
   end

   def update
       super do |resource|
         account = resource.accounts[0]

         session["account_id"] = account.id if(account)
       end
   end
   def edit
       super
   end
end
