# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  body       :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many_attached :images

  validates :body,
            presence: true,
            if: -> { new_record? || changes[:body] }

  validates :images,
            blob: {
              content_type: ['image/png', 'image/jpg', 'image/jpeg'],
              size_range: 1..(5.megabytes)
            }

  validates :images,
            presence: true,
            if: -> {  new_record? }

  def self.ransackable_attributes(auth_object = nil)
    ["body"]
  end
  
  def self.ransackable_associations(auth_object = nil)
    ["comments","user"]
  end

end
