class RenameTrialPeriodDays < ActiveRecord::Migration
  def change
    rename_column :plans, :trail_period_days, :trial_period_days
  end
end
