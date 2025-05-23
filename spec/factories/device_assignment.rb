# frozen_string_literal: true
FactoryBot.define do
  factory :device_assignment do
    user
    device
    returned {false}
  end
end