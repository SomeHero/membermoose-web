class Dashboard::Users::PasswordsController < Devise::PasswordsController
   def create
     super
   end

   def new
       super
   end

   def update
       super do |resource|
         session["account_id"] = resource.account.id
       end
   end
   def edit
       super
   end
end
