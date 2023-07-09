# Esta clase se encarga de:
# - Validar que se reciba un archivo csv
# - Iterar sobre las líneas del archivo
# - Validar que la cabecera del archivo csv es el esperado
class Imports::Csv
  def initialize(csv_file_path, expected_columns)
    @csv_file_path = csv_file_path
    @expected_columns = expected_columns
    @successful_import_count = 0
    @rows_errors = {}
    @errors = []
  end

  def foreach
    return unless valid_file?

    CSV.foreach(@csv_file_path, headers: true) do |row|
      break unless valid_columns?(row.headers)

      yield(row, @rows_errors)
    end
  end

  def import
    ActiveRecord::Base.transaction do
      @successful_import_count = yield
    end
  rescue StandardError
    @errors << I18n.t("services.imports.messages.unexpected_error")
  end

  def result
    return validation_errors_msg if @errors.any?
    result_msg
  end

  private

  def rows_errors
    @rows_errors.map { |key, value| " #{I18n.t("services.imports.row")} #{key} => #{value}"}.join(", ")
  end

  def validation_errors_msg
    msg = I18n.t("services.imports.messages.import_fail")
    msg << ". " +  @errors.join(". ")
    msg
  end

  def result_msg
    msg = I18n.t("services.imports.messages.imported_records", count: @successful_import_count)
    msg << ". " + I18n.t("services.imports.messages.no_imported_records", rows_errors: rows_errors) if @rows_errors.any?
    msg
  end

  def valid_file?
    if @csv_file_path.blank?
      @errors << I18n.t("services.imports.messages.blank_csv_file")
      return false
    end
    true
  end

  def valid_columns?(received_columns)
    missing_columns = @expected_columns - received_columns
    if missing_columns.any?
      @errors << I18n.t("services.imports.messages.missing_columns", missing_columns: missing_columns.join(", "))
      return false
    end
    true
  end
end
