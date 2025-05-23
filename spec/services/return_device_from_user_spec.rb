# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReturnDeviceFromUser do
  subject(:return_device) do
    described_class.new(
      user: user,
      serial_number: device.serial_number
    ).call

  end
  let(:user) { create(:user) }
  let(:device) { create(:device, serial_number: '123456') }

  context 'when user returns a device assigned to themself' do
    before do
      AssignDeviceToUser.new(
        requesting_user: user,
        serial_number: device.serial_number,
        new_device_owner_id: user.id
      ).call
    end

    it 'successfully returns device' do
      expect(return_device).not_to raise_error
      expect(DeviceAssignment.find_by(user: user, device: device).returned).to eq(true)
    end
  end

end
