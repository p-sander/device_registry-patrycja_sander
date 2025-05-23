class User < ApplicationRecord
  has_secure_password

  has_many :device_assignments, dependent: :destroy
  has_many :devices, through: :device_assignments

  has_many :active_device_assignments,
           -> { where(device_assignments: { returned: false }) },
           through: :device_assignments,
           source: :device

  has_many :returned_devices,
           -> { where(device_assignments: { returned: true }) },
           through: :device_assignments,
           source: :device

  has_many :api_keys, as: :bearer

  validates :username, presence: true, uniqueness: true
  validate :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
