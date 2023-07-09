require "rails_helper"

RSpec.describe Imports::StudentCsv do
  describe "#import" do
    context "with valid csv content" do
      before do
        FactoryBot.create(:career, name: "Ingenieria Electromecanica")
        FactoryBot.create(:career, name: "Ingenieria Civil")

        csv_file_path = Rails.root.join("spec/support/files/valid_students.csv")
        @student_csv = Imports::StudentCsv.new(csv_file_path)
        @result = @student_csv.import
      end

      it "populate person" do
        expect(Person.count).to eq(2)
      end

      it "populate student" do
        expect(Student.count).to eq(2)
      end

      it "import without errors" do
        expect(@result).to eq("Se importaron 2 registros")
      end
    end

    context "with invalid csv content" do
      before do
        FactoryBot.create(:career, name: "Ingenieria Civil")

        csv_file_path = Rails.root.join("spec/support/files/invalid_students.csv")
        @student_csv = Imports::StudentCsv.new(csv_file_path)
        @result = @student_csv.import
      end

      it "not populate person" do
        expect(Person.count).to eq(0)
      end

      it "not populate student" do
        expect(Student.count).to eq(0)
      end

      it "import without errors" do
        expect(@result).to eq("Se importaron 0 registros. Filas no importadas:  Fila 1 => Carrera debe existir y Carrera no puede estar en blanco,  Fila 2 => Correo no puede estar en blanco y Correo no es válido")
      end
    end

    context "without file" do
      before do
        @student_csv = Imports::StudentCsv.new(nil)
        @result = @student_csv.import
      end

      it "not populate person" do
        expect(Person.count).to eq(0)
      end

      it "not populate student" do
        expect(Student.count).to eq(0)
      end

      it "import without errors" do
        expect(@result).to eq("No se pudo importar ningún registro. No se recibió ningún archivo")
      end
    end

    context "with invalid csv columns" do
      before do
        csv_file_path = Rails.root.join("spec/support/files/invalid_students_columns.csv")
        @student_csv = Imports::StudentCsv.new(csv_file_path)
        @result = @student_csv.import
      end

      it "not populate person" do
        expect(Person.count).to eq(0)
      end

      it "not populate student" do
        expect(Student.count).to eq(0)
      end

      it "import without errors" do
        expect(@result).to eq("No se pudo importar ningún registro. No se encontraron las columnas: last_name en el archivo indicado")
      end
    end

    context "when raise RuntimeError into import" do
      before do
        csv_file_path = Rails.root.join("spec/support/files/valid_students.csv")
        @student_csv = Imports::StudentCsv.new(csv_file_path)
        allow(Person).to receive(:import).and_raise(RuntimeError) # Force Exception when import
        @result = @student_csv.import
      end

      it "not populate person" do
        expect(Person.count).to eq(0)
      end

      it "not populate student" do
        expect(Student.count).to eq(0)
      end

      it "import without errors" do
        expect(@result).to eq("No se pudo importar ningún registro. Ocurrió un error al importar el archivo. Por favor, intente de nuevo")
      end
    end
  end
end
