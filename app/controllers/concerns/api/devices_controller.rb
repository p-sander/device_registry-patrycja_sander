# frozen_string_literal: true

module Api
  class DevicesController < ApplicationController
    before_action :authenticate_user!, only: %i[assign unassign]

    def assign
      AssignDeviceToUser.new(
        requesting_user: current_user,
        serial_number: params[:device][:serial_number],
        new_device_owner_id: params[:new_owner_id]
      ).call

      head :ok
    rescue RegistrationError::Unauthorized => e
      render json: { error: 'Unauthorized' }, status: :unprocessable_entity
    rescue ArgumentError, ActiveRecord::RecordInvalid => e
      render json: { error: e.message }, status: :unprocessable_entity
    end

    def unassign
      ReturnDeviceFromUser.new(
        user: current_user,
        serial_number: params[:serial_number]
      ).call

      head :ok
    rescue ReturningError::AlreadyReturnedDevice, ReturningError::ReturnWhatIsNotAssignedToUser => e
      render json: { error: e.message }, status: :unprocessable_entity
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: e.message }, status: :not_found
    end

    private

    def authenticate_user!
      token = request.headers['Authorization']&.split(' ')&.last || session[:token]
      @current_user = ApiKey.find_by(token: token)&.bearer
      render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
    end

    def current_user
      @current_user
    end
  end
end
