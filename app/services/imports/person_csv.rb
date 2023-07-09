require Rails.root.join("lib/utility")
class Imports::PersonCsv
  EXPECTED_COLUMNS = %w[first_name last_name email phone_number id_card address career]
  TRANSLATED_SEX = I18n.t("activerecord.attributes.person.sexes").invert.transform_keys(&:downcase)

  def initialize(csv_file_path)
    @csv = Imports::Csv.new(csv_file_path, EXPECTED_COLUMNS)
    @persons = []
  end

  def foreach
    index = 0

    @csv.foreach do |row, rows_errors|
      index += 1

      person = Person.new(person_attributes(row))
      yield(person, career_ids(row))

      if person.errors.empty? && person.valid?
        @persons << person
      else
        rows_errors[index] = person.errors.full_messages.to_sentence
      end
    end
  end

  def import
    @csv.import do
      import_result = Person.import(@persons, validate: false, recursive: true)
      import_result.ids.size
    end

    @csv.result
  end

  private

  def careers
    @_careers ||=
      begin
        careers = Career.pluck(:name, :id).to_h
        careers.transform_keys { |key| Utility.clean_string(key) }
      end
  end

  def career_ids(row)
    career_names = Utility.clean_string(row["career"])
    career_names.split(",").map {|career_name| careers[career_name]}.compact
  end

  def person_attributes(row)
    attrs = row.to_h.except("career", "sex")
    attrs["sex"] = TRANSLATED_SEX[Utility.clean_string(row["sex"])]
    attrs
  end
end
