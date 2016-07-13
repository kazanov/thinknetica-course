require 'rails_helper'
RSpec.describe SearchController, type: :controller do

  describe "GET #index" do
    it 'calls Search #find' do
      expect(Search).to receive(:find).with('123', 'all')
      get :index, query: '123', type: 'all'
    end

    it 'renders index template' do
      get :index, query: '123', type: 'all'
      expect(response).to render_template 'index'
    end

    it 'returns status 200' do
      get :index, query: '123', type: 'all'
      expect(response.status).to eq 200
    end
  end
end
