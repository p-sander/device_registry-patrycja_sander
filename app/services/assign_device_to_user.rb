# frozen_string_literal: true

class AssignDeviceToUser
  attr_reader :requesting_user, :serial_number, :new_device_owner_id

  def initialize(requesting_user:, serial_number:, new_device_owner_id:)
    @requesting_user = requesting_user
    @serial_number = serial_number
    @new_device_owner_id = new_device_owner_id.to_i
  end

  def call
    validate_inputs!
  end


  private

  def validate_inputs!
    raise ArgumentError, "No user" if requesting_user.nil?
    raise ArgumentError, "No serial number" if serial_number.nil?
    raise ArgumentError, "No id of the owner" if new_device_owner_id.zero?
  end
end
