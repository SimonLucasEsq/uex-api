require "rails_helper"

RSpec.describe Api::ProfessorsController, type: :controller do
  before do
    login
  end

  describe "POST #import" do
    before do
      post :import_csv, params: { file: fixture_file_upload(Rails.root.join("spec/support/files/valid_professors.csv"), 'text/csv') }
    end

    it "returns result message" do
      expect(JSON.parse(response.body)["message"]).to eq("Se importaron 2 registros")
    end

    it "returns a success response" do
      expect(response).to have_http_status(:ok)
    end
  end
end
