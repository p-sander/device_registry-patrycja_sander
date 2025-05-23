# frozen_string_literal: true

module ReturningError
  class Base < StandardError; end

  #error when user tries to return a device that had been returned
  class AlreadyReturnedDevice < Base; end

  #eror when user tries to return a device that is not assigned to themself
  class ReturnWhatIsNotAssignedToUser < Base; end
end
