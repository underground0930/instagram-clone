# == Schema Information
#
# Table name: notifications
#
#  id         :bigint           not null, primary key
#  title      :string(255)      not null
#  url        :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Notification < ApplicationRecord
  has_many :user_notifications, depedent: :destroy
  has_many :users, through: :user_notifications

  validates :title, presence: true
  validates :url, presence: true, format: /\A#{URI::DEFAULT_PARSER.make_regexp(%w[http https])}\z/

  def notify(*user)
    users = user.flatten
    user_notifications = users.pluck(:id).map do |user_id|
      { notification_id: id, user_id: }
    end
    UserNotification.insert_all(user_notifications)
  end
end
