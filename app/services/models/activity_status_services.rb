class Models::ActivityStatusServices < ApplicationService
  ALLOWED_STATUSES = [:draft, :evaluated, :sent_to_deanery, :rejected, :approved, :declined].freeze

  def initialize(activity, params)
    @activity = activity
    @params = params
  end

  def call
    super

    send("update_status_to_#{status}!")

    @activity
  end

  private

  def validate_params!
    raise "Missing activity" unless @activity
    raise "Missing params" unless @params
    raise "Missing status" unless status
    raise "Status #{status} is not allowed" unless ALLOWED_STATUSES.include?(status)
  end

  def status
    @_status ||= @params[:status].to_sym
  end

  def update_status_to_draft!
    @activity.update!(status: status)
  end

  def update_status_to_evaluated!
    raise "Missing evaluation param" unless @params[:evaluation]
    raise "Evaluation must be greter than or equal to 60" if (@params[:evaluation].to_i < 60)

    @activity.update!(status: status, evaluation: @params[:evaluation])
  end

  def update_status_to_declined!
    raise "Missing evaluation param" unless @params[:evaluation]
    raise "Evaluation must be less than 60" if (@params[:evaluation].to_i >= 60)

    @activity.update!(status: status, evaluation: @params[:evaluation])
  end

  def update_status_to_sent_to_deanery!
    @activity.update!(status: status)
  end

  def update_status_to_rejected!
    @activity.update!(status: status)
  end

  def update_status_to_approved!
    raise "Missing approved_at param" unless @params[:approved_at]
    raise "Missing resolution_number param" unless @params[:resolution_number]

    @activity.update!(status: status, approved_at: @params[:approved_at], resolution_number: @params[:resolution_number])
  end
end