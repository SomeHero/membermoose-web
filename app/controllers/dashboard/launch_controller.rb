class Dashboard::LaunchController < DashboardController
  layout :determine_layout

  def index
    Rails.logger.info("Attempting to Update Card")

  end
end
