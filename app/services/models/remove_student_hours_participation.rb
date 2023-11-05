class Models::RemoveStudentHoursParticipation < ApplicationService

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
 
    ActivityWeekParticipant.transaction do
      student_participants.each do |participant|
        next if !participant._destroy

        student = students[participant.participable_id]
        next unless student

        if participant.registered_hours
          student.hours = student.hours - participant.registered_hours
          student.status = Student.eligible_status(student)
        end

        students_to_update << student
      end

      Student.import!(students_to_update.uniq, on_duplicate_key_update: [:hours, :status])
    end

    @activity_week_participants
  end

  def students
    @_students ||= Student.where(id: student_participants.map(&:participable_id).uniq).index_by(&:id)
  end

  def student_participants
    @_student_participants ||= @activity_week_participants.select { |participant| participant.participable_type == Student.to_s }
  end
end
