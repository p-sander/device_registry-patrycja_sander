# frozen_string_literal: true

class ReturnDeviceFromUser
  attr_reader :user, :serial_number
  def initialize(user:, serial_number:)
    @user = user
    @serial_number = serial_number
  end

  def call
    validate_inputs!
    device = find_device(serial_number)
    device_assignment = find_device_assignment(user, device)
  end

  private

  def validate_inputs!
    raise ArgumentError, "No user" if user.nil?
    raise ArgumentError, "No serial number" if serial_number.blank?
  end

  def find_device(serial_number)
    Device.find_by(serial_number) ||
      raise(ActiveRecord::RecordNotFound)
  end

  def find_device_assignment(user, device)
    DeviceAssignment.find_by(user, device) ||
      raise(RegistrationError::Unauthorized, "You cannot return a device you did not assign.")
  end
end

