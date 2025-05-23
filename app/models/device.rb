class Device < ApplicationRecord
  has_many :device_assignments, dependent: :destroy

  has_one :active_device_assignment,
          -> { where(returned: false) },
          class_name: "DeviceAssignment"

  has_one :current_user,
          through: :active_device_assignment,
          source: :user

  belongs_to :user, optional: true

  validates :serial_number, presence: true, uniqueness: true
end
