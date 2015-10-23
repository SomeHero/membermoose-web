# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'
Rails.application.config.assets.precompile += %w( application-dashboard.css )
Rails.application.config.assets.precompile += %w( public/application.js dashboard/application.js bulls/application.js )
Rails.application.config.assets.precompile += %w( application-bulls.css )
Rails.application.config.assets.paths << Rails.root.join('app', 'assets', 'fonts')
Rails.application.config.assets.paths << "#{Rails}/vendor/assets/fonts"
# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
