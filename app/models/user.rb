# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  before_validation do
    self.email = email.to_s.downcase
    self.username = username.to_s.downcase
  end

  validates_length_of     :password, maximum: 30, minimum: 8, allow_nil: true, allow_blank: false
  validates_presence_of   :email, :username
  validates_uniqueness_of :email, :username

  def admin?
    role == 'admin'
  end
end
