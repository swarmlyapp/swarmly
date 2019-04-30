# Auto generate with notifications gem.
class Notification < ApplicationRecord
  include Notifications::Model

  def self.notify_follow(user_id, follower_id)
    opts = {
      notify_type: "follow",
      user_id: user_id,
      actor_id: follower_id
    }
    Notification.create opts
  end
end
