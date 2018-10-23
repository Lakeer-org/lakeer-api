class ApiKey
  include Mongoid::Document
  include Mongoid::Timestamps
  
  before_create :generate_access_token
  before_create :set_expiration

  belongs_to :user

  field :access_token,              type: String
  field :expires_at,                type: Time
  field :active,                    type: Boolean

  def expired?
    DateTime.now >= self.expires_at
  end

  private
  def generate_access_token
    token = SecureRandom.hex
    unless self.class.where(access_token: token).present?
      self.access_token = token
    end
  end

  def set_expiration
    self.expires_at = DateTime.now+30
  end

end
