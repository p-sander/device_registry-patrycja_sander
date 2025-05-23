require 'rails_helper'

RSpec.describe Api::DevicesController, type: :controller do
  let(:user) { create(:user) }
  let(:api_key) { create(:api_key, bearer: user) }

  before do
    # Simulujemy nagłówek Authorization z tokenem
    request.headers['Authorization'] = "Token #{api_key.token}"
  end

  describe 'POST #assign' do
    subject(:assign) do
      post :assign,
           params: {
             new_owner_id: new_owner_id,
             device: { serial_number: 'XYZ123' }
           }
    end

    context 'when user assigns device to another user' do
      let(:new_owner_id) { create(:user).id }

      it 'returns unauthorized' do
        assign
        expect(response.status).to eq(422)
        expect(response.parsed_body).to eq({ 'error' => 'Unauthorized' })
      end
    end

    context 'when user assigns device to self' do
      let(:new_owner_id) { user.id }

      it 'returns success' do
        assign
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'POST #unassign' do
    let(:serial_number) { 'ABC123' }

    before do
      AssignDeviceToUser.new(
        requesting_user: user,
        serial_number: serial_number,
        new_device_owner_id: user.id
      ).call
    end

    subject(:unassign) do
      post :unassign,
           params: { serial_number: serial_number }
    end

    it 'returns success when unassigning own device' do
      unassign
      expect(response).to have_http_status(:ok)
    end
  end
end
