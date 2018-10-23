class User
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :api_keys
  has_many :indices, dependent: :delete_all

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  ## Database authenticatable
  field :email,                   type: String, default: ""
  field :first_name,              type: String, default: ""
  field :last_name,               type: String, default: ""
  field :encrypted_password,      type: String, default: ""
  field :is_admin,                type: Boolean, default: false
  field :gender,                  type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  # field :sign_in_count,      type: Integer, default: 0
  # field :current_sign_in_at, type: Time
  # field :last_sign_in_at,    type: Time
  # field :current_sign_in_ip, type: String
  # field :last_sign_in_ip,    type: String

  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time

  def full_name
    "#{first_name.try(:titleize)} #{last_name.try(:titleize)}"
  end

  scope :search, lambda { |searchterm|
    return nil  if searchterm.blank?
    any_of({first_name: /.*#{searchterm}.*/}, {last_name: /.*#{searchterm}.*/}, {email: /.*#{searchterm}.*/})
  }

  def set_password_reset_token(url)
    self.update(reset_password_token: SecureRandom.urlsafe_base64.to_s, reset_password_sent_at: DateTime.now)
    ResetPasswordEmailJob.perform_now(self, url)
  end

end
