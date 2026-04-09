class PlanExpiryJob < ApplicationJob
  queue_as :default

  def perform
    users = User.where("plan_expiry IS NOT NULL AND plan_expiry < ?", Time.current)

    users.find_each do |user|
      next if user.plan_type == "free"

      user.update(
        plan_type: "free",
        plan_expiry: nil
      )
    end
  end
end