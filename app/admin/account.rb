ActiveAdmin.register Account do
  permit_params :user, :address, :first_name, :last_name, :company_name, :phone_number
  filter :first_name
  filter :last_name
  filter :company_name
end
