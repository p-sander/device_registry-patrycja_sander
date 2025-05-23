# frozen_string_literal: true

module RegistrationError
  class Unauthorized < StandardError; end
  class ValidationError < StandardError; end
end
