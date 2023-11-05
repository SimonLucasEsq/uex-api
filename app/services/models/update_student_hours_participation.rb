class Models::UpdateStudentHoursParticipation < ApplicationService

  def initialize(activity_week_participants)
    @activity_week_participants = activity_week_participants
  end

  def call
    super

    register_hours!
  end

  private
  def validate_params!
    raise "Missing activity_week_participants param" unless @activity_week_participants
  end

  def register_hours!
    students_to_update = []
    participants_to_update = []
 
    ActivityWeekParticipant.transaction do
      student_participants.each do |participant|
        next if participant._destroy || participant.hours == participant.registered_hours

        student = students[participant.participable_id]
        next unless student

        calculate_hours!(student, participant)
        student.status = Student.eligible_status(student)
        students_to_update << student
        participants_to_update << participant
      end

      Student.import!(students_to_update.uniq, on_duplicate_key_update: [:hours, :status])
      ActivityWeekParticipant.import!(participants_to_update.uniq, on_duplicate_key_update: [:registered_hours])
    end

    @activity_week_participants
  end

  def calculate_hours!(student, participant)
    new_hours = student.hours
    new_hours -= participant.registered_hours if participant.registered_hours
    new_hours += participant.hours

    acumulated_hours = student_hours_by_activity_sub_type(student, participant)

    if (new_hours + acumulated_hours) <= participant.activity_sub_type.hours || participant.activity_sub_type.unlimited_hours
      student.hours = (new_hours + acumulated_hours)
      participant.registered_hours = participant.hours
    else
      student.hours = participant.activity_sub_type.hours
      participant.registered_hours = student.hours - acumulated_hours 
    end
  end

  def student_hours_by_activity_sub_type(student, participant)
    hours_by_type = 0
    student = student.activity_week_participants.each do |awp|
      next unless awp.registered_hours
      next if awp.id == participant.id || awp.activity_sub_type_id != participant.activity_sub_type_id

      hours_by_type += awp.registered_hours
    end

    hours_by_type
  end

  def students
    @_students ||= Student.where(id: student_participants.map(&:participable_id).uniq).includes(:activity_week_participants).index_by(&:id)
  end

  def student_participants
    @_student_participants ||= @activity_week_participants.select { |participant| participant.participable_type == Student.to_s }
  end
end
