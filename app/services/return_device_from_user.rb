# frozen_string_literal: true

class ReturnDeviceFromUser
  def initialize(user:, serial_number:)
    @user = user
    @serial_number = serial_number
  end

  def call
    device = find_device(@serial_number)
  end

  private
  def find_device(serial_number)
    Device.find_by(serial_number) ||
      raise(ActiveRecord::RecordNotFound)
  end
end

