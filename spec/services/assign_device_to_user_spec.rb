# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AssignDeviceToUser do
  subject(:assign_device) do
    described_class.new(
      requesting_user: user,
      serial_number: serial_number,
      new_device_owner_id: new_device_owner_id
    ).call
  end

  let(:user) { create(:user) }
  let(:serial_number) { '123456' }

  context 'when user registers a device to another user' do
    let(:new_device_owner_id) { create(:user).id }

    it 'raises a RegistrationError::Unauthorized' do
      expect { assign_device }.to raise_error(RegistrationError::Unauthorized)
    end
  end

  context 'when user registers a device to self' do
    let(:new_device_owner_id) { user.id }

    it 'creates a new device' do
      assign_device
      expect(user.devices.pluck(:serial_number)).to include(serial_number)
    end

    context 'when the device was already assigned and returned by the same user' do
      let(:new_device_owner_id) { user.id }

      before do
        described_class.new(
          requesting_user: user,
          serial_number: serial_number,
          new_device_owner_id: user.id
        ).call

        ReturnDeviceFromUser.new(
          user: user,
          serial_number: serial_number
        ).call

        user.reload
        DeviceAssignment.last.reload
      end

      it 'does not allow to register the device again' do
        expect(DeviceAssignment.where(user: user, returned: true).count).to eq(1)
        expect {
          described_class.new(
            requesting_user: user,
            serial_number: serial_number,
            new_device_owner_id: user.id
          ).call
        }.to raise_error(AssigningError::AlreadyUsedOnUser)
      end
    end

    context 'when the device is currently assigned to another user' do
      let(:other_user) { create(:user) }

      before do
        AssignDeviceToUser.new(
          requesting_user: other_user,
          serial_number: serial_number,
          new_device_owner_id: other_user.id
        ).call
      end

      it 'raises AssigningError::AlreadyUsedOnOtherUser' do
        expect { assign_device }.to raise_error(AssigningError::AlreadyUsedOnOtherUser)
      end
    end
  end
end