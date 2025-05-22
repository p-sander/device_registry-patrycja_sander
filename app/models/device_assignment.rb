# frozen_string_literal: true

class DeviceAssignment < ApplicationRecord
  belongs_to :user
  belongs_to :device

  validates :device_id, presence: true
  validates :device_id, uniqueness: { scope: :user_id, message: "The device with id:  " + :device_id.to_s + " is already assigned to user with id:  " + :user_id.to_s }
end
