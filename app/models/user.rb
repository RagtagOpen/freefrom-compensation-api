class User < ApplicationRecord
  has_secure_password

  before_validation { 
    (self.email = self.email.to_s.downcase) && (self.username = self.username.to_s.downcase) 
  }

  validates_length_of     :password, maximum: 30, minimum: 8, allow_nil: true, allow_blank: false
  validates_presence_of   :email, :username
  validates_uniqueness_of :email, :username

  def admin?
    role == 'admin'
  end
end
