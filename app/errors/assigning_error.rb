# frozen_string_literal: true

module AssigningError
  class Base < StandardError; end

  # error when the user tries to assign to himself a device that he returned
  class AlreadyUsedOnUser < Base; end

  # error when user tries to assign a device, that belongs to someone else
  class AlreadyUsedOnOtherUser < Base; end

  #error when user tries to return a device that had been returned
  class AlreadyReturnedDevice < Base; end
end
