class Imports::StudentCsv
  def initialize(csv_file_path)
    @person_csv = Imports::PersonCsv.new(csv_file_path)
  end

  def import
    @person_csv.foreach do |person, career_ids|
      person.build_student(career_id: career_ids.first)
      person.merge_errors(person.student) unless person.student.valid?
    end

    @person_csv.import
  end
end
