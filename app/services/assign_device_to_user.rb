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
    future_device_owner = find_new_device_owner
    compare_requesting_user_and_new_device_owner(future_device_owner)
    device = find_device_by_serial_number
  end

  private

  def validate_inputs!
    raise ArgumentError, "No user" if requesting_user.nil?
    raise ArgumentError, "No serial number" if serial_number.nil?
    raise ArgumentError, "No id of the owner" if new_device_owner_id.zero?
  end

  def find_new_device_owner
    User.find_by(id: new_device_owner_id) ||
      raise(ActiveRecord::RecordNotFound, "No user with id #{new_device_owner_id}")
  end

  def compare_requesting_user_and_new_device_owner(new_device_owner)
    unless requesting_user == new_device_owner
      raise ArgumentError, "You can't assign a device to someone else, just to yourself"
    end
  end

  def find_device_by_serial_number
    Device.find_by(serial_number: serial_number) ||
      raise(ActiveRecord::RecordNotFound, "No device with serial number #{serial_number}")
  end
end
