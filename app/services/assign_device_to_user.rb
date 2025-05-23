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
    compare_requesting_user_and_new_device_owner!(future_device_owner)

    device = find_or_create_device_by_serial_number(serial_number)

    check_if_assignment_exists_for_user_and_device!(future_device_owner, device)

    assign_device_to_user(future_device_owner, device)
  end

  private

  def validate_inputs!
    raise ArgumentError, "No user" if requesting_user.nil?
    raise ArgumentError, "No serial number" if serial_number.blank?
    raise ArgumentError, "No id of the owner" if new_device_owner_id.zero?
  end

  def find_new_device_owner
    User.find_by(id: new_device_owner_id) ||
      raise(ActiveRecord::RecordNotFound, "No user with id #{new_device_owner_id}")
  end

  def compare_requesting_user_and_new_device_owner!(new_device_owner)
    unless requesting_user == new_device_owner
      raise RegistrationError::Unauthorized, "You can't assign a device to someone else, just to yourself"
    end
  end

  def find_or_create_device_by_serial_number(serial_number)
    Device.find_or_create_by!(serial_number: serial_number)
  rescue ActiveRecord::RecordInvalid => e
    raise ActiveRecord::RecordInvalid, "Failed to create device: #{e.message}"
  end

  def check_if_assignment_exists_for_user_and_device!(user, device)
    if DeviceAssignment.where(user: user, device: device, returned: true).exists?
      raise AssigningError::AlreadyUsedOnUser, "You already assigned to this device once, you can't do it again"
    end

    if DeviceAssignment.where(device: device, returned: false).where.not(user_id: user.id).exists?
      raise AssigningError::AlreadyUsedOnOtherUser, "This device is already actively assigned to another user."
    end
  end

  def assign_device_to_user(user, device)
    assignment = DeviceAssignment.new(user: user, device: device, returned: false)
    if assignment.save
      assignment
    else
      if assignment.errors[:device_id].any? { |msg| msg.include?("already assigned") }
        raise AssigningError::AlreadyUsedOnOtherUser, "This device is already actively assigned to another user."
      else
        raise ActiveRecord::RecordInvalid, assignment.errors.full_messages.join(',')
      end
    end
  end
end
