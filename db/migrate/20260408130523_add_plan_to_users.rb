class AddPlanToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :plan_type, :string
    add_column :users, :plan_expiry, :datetime
  end
end
