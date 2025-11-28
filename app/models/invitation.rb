class Invitation < ApplicationRecord
  belongs_to :project

  before_create :generate_token
  validates :email, presence: true,
    format: { with: User::REGEX_EMAIL, message: 'not valid e-mail format' }   
    
  def generate_token
    self.token ||= SecureRandom.hex(10)
  end

  def expired?
    expires_at < Time.current
  end

end
