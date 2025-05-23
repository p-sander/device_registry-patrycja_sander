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
    authorise_return!(device_assignment)
    mark_as_returned!(device_assignment)
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
    DeviceAssignment.find_by(user: user, device: device) ||
      raise(ActiveRecord::RecordNotFound, "This device is not assigned to this user")
  end

  def authorise_return!(device_assignment)
    unless device_assignment.user == user
      raise(ReturningError::ReturnWhatIsNotAssignedToUser, "Only the assigned user can return this device.")
    end
  end

  def check_if_device_was_not_returned_before(device_assignment)
    if device_assignment.returned == true
      # raise AssigningError::AlreadyUsedOnUser, "This device has already been returned."
      raise ReturningError::AlreadyReturnedDevice, "This device has already been returned."
    end
  end

  def mark_as_returned!(device_assignment)
    check_if_device_was_not_returned_before(device_assignment)

    device_assignment.update!(returned: true)
    device_assignment
  rescue  ActiveRecord::RecordInvalid => e
    raise RegistrationError::ValidationError.new(e.message)
  end
end

