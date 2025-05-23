# frozen_string_literal: true

class AssignDeviceToUser
  attr_reader :requesting_user, :serial_number, :new_device_owner_id
  def initialize(requesting_user:, serial_number:, new_device_owner_id:)
    @requesting_user = requesting_user
    @serial_number = serial_number
    @new_device_owner_id = new_device_owner_id.to_i
  end

  def call
  end

end
