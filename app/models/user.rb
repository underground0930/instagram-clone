# == Schema Information
#
# Table name: users
#
#  id                           :bigint           not null, primary key
#  crypted_password             :string(255)
#  email                        :string(255)      not null
#  remember_me_token            :string(255)
#  remember_me_token_expires_at :datetime
#  salt                         :string(255)
#  username                     :string(255)      not null
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#
# Indexes
#
#  index_users_on_email              (email) UNIQUE
#  index_users_on_remember_me_token  (remember_me_token)
#  index_users_on_username           (username) UNIQUE
#
class User < ApplicationRecord
  authenticates_with_sorcery!

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :password,
            length: { minimum: 3, maximum: 20 },
            if: -> { new_record? || changes[:crypted_password] }
  validates :password,
            confirmation: true,
            if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation,
            presence: true,
            if: -> { new_record? || changes[:crypted_password] }

  validates :email,
            uniqueness: true,
            presence: true,
            format: { with: VALID_EMAIL_REGEX }

  validates :username,
            uniqueness: true,
            presence: true
end
