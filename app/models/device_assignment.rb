# frozen_string_literal: true

class DeviceAssignment < ApplicationRecord
  belongs_to :user
  belongs_to :device

  validates :user_id, presence: true
  validates :device_id, presence: true
  validates :device_id,
            uniqueness: {
              scope: [:user_id],
              conditions: -> { where(returned: false) },
              message: "This device is already assigned to this user and has not been returned."
            }

  scope :returned, -> { where(returned: true) }
  scope :active, -> { where(returned: false) }

  def not_returned?
    !returned
  end
end
