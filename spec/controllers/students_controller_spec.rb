require "rails_helper"

RSpec.describe Api::StudentsController, type: :controller do
  before do
    login
  end

  describe "POST #import" do
    context "with file" do
      before do
        FactoryBot.create(:career, name: "Ingenieria Electromecanica")
        post :import_csv, params: {file: fixture_file_upload(Rails.root.join("spec/support/files/valid_students.csv"), 'text/csv')}
      end

      it "returns result message" do
        expect(JSON.parse(response.body)["message"]).to eq("Se importaron 1 registros. Filas no importadas:  Fila 2 => Carrera debe existir")
      end

      it "returns a success response" do
        expect(response).to have_http_status(:ok)
      end
    end

    context "without file" do
      before do
        FactoryBot.create(:career, name: "Ingenieria Electromecanica")
        post :import_csv
      end

      it "returns result message" do
        expect(JSON.parse(response.body)["message"]).to eq("No se recibió ningún archivo")
      end

      it "returns a success response" do
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
