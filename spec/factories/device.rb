# frozen_string_literal: true
FactoryBot.define do
  factory :device do
    serial_number {Faker::Device.serial}
  end
end
