class Api::ActivityWeeksController < Api::BaseController
  before_action :set_activity_week, only: [:create, :show, :update, :destroy, :register_hours]

  def create
    @activity_week.save!
    render json: @activity_week
  end

  def index
    activity_weeks = ActivityWeek.search(params).paginate(page: page, per_page: per_page)
    render json: activity_weeks, each_serializer: ActivityWeekSerializer, meta: meta_attributes(activity_weeks)
  end

  def show
    render json: @activity_week
  end

  def update
    Models::UpdateActivityWeekServices.call(@activity_week, activity_week_params)

    render json: @activity_week.reload
  end

  def destroy
    @activity_week.destroy!
  end

  def register_hours
    Models::UpdateStudentHoursParticipation.call(@activity_week.activity_week_participants)

    render json: @activity_week
  end

  private
  def set_activity_week
    @activity_week = if params[:id]
      ActivityWeek.find(params[:id])
    else
      ActivityWeek.new(activity_week_params)
    end
  end

  def activity_week_params
    return @activity_week_params if @activity_week_params

    params[:activity_week][:activity_week_participants_attributes] = params[:activity_week].delete(:activity_week_participants)
    @activity_week_params = params
      .require(:activity_week)
      .permit(:id, :activity_id, :start_date, :end_date, activity_week_participants_attributes:
        [:id, :activity_week_id, :activity_sub_type_id, :participable_id, :participable_type, :hours, :evaluation, :description, :_destroy])
  end
end
