require 'rails_helper'

RSpec.describe "Screens", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/screens/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/screens/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/screens/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/screens/create"
      expect(response).to have_http_status(:success)
    end
  end

end
