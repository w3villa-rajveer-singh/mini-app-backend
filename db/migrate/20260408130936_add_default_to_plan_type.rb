class AddDefaultToPlanType < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :plan_type, "free"
  end
end