class CreateActivityServices < ApplicationService
  def initialize(params)
    @params = params
  end

  def call
    super

    {
      record: create_record!
    }
  end

  def create_record!
    activity = Activity.new(@params)
    activity.status = :draft
    activity.activity_weeks << ActivityWeek.new({ start_date: activity.start_date, end_date: activity.end_date })
    activity.save!

    activity
  end

  private

  def validate_params!
    raise "Missing activity params" unless @params
  end
end
