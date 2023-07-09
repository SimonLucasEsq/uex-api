class Imports::ProfessorCsv
  def initialize(csv_file_path)
    @person_csv = Imports::PersonCsv.new(csv_file_path)
  end

  def import
    @person_csv.foreach do |person, career_ids|
      person.build_professor
      person.professor.career_ids = career_ids
      person.merge_errors(person.professor) unless person.professor.valid?
    end

    @person_csv.import
  end
end
