class Models::UpdateStudentStatusServices < ApplicationService
  ALLOWED_STATUSES = [:to_be_submitted, :submitted].freeze

  def initialize(student, status)
    @student = student
    @status = status
  end

  def call
    super

    raise "Cannot update status from insuficient to remitted" if @student.status == :insuficient.to_s
    @student.update!(status: @status)

    @student
  end

  private

  def validate_params!
    raise "Missing student" unless @student
    raise "Missing status" unless @status
    raise "Status #{@status} is not allowed" unless ALLOWED_STATUSES.include?(@status.to_sym)
  end
end