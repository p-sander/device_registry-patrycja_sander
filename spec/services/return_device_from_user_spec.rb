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



end
