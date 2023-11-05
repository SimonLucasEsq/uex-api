class Models::UpdateActivityWeekServices < ApplicationService
  def initialize(activity_week, activity_week_params)
    @activity_week = activity_week
    @activity_week_params = activity_week_params
  end

  def call
    super

    update!
  end

  def update!
    ActivityWeek.transaction do
      @activity_week.assign_attributes(@activity_week_params)
      
      # Business logic, only when at least one participant hour was registered we can update student hours
      registered_hours = @activity_week.activity_week_participants.any? { |p| p.registered_hours }
      Models::RemoveStudentHoursParticipation.call(@activity_week.activity_week_participants) if registered_hours
      @activity_week.save!
      perform_update_student_hours(@activity_week.activity_week_participants) if registered_hours
    end

    @activity_week
  end

  private

  def perform_update_student_hours(activity_week_participants)
    Models::UpdateStudentHoursParticipation.call(activity_week_participants)
  end

  def validate_params!
    raise "Missing activity_week" unless @activity_week
    raise "Missing activity_week_params" unless @activity_week_params
  end
end
