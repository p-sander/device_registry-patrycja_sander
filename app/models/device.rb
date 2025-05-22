class Device < ApplicationRecord
  has_one :device_assignment, -> { where(returned: false) }, class_name: "DeviceAssignment"
  belongs_to :user
end
