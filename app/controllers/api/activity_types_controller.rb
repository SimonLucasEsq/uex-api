class Api::ActivityTypesController < Api::BaseController
  before_action :set_activity_type, only: [:create, :show, :update, :destroy]

  def create
    @activity_type.save!
    render json: @activity_type
  end

  def index
    activity_types = ActivityType.includes(:activity_sub_types).search(params).paginate(page: page, per_page: per_page)
    render json: activity_types, each_serializer: ActivityTypeSerializer, meta: meta_attributes(activity_types)
  end

  def show
    render json: @activity_type
  end

  def update
    @activity_type.update!(activity_type_params)
    render json: @activity_type
  end

  def destroy
    @activity_type.destroy!
  end

  private
  def set_activity_type
    @activity_type = if params[:id]
      ActivityType.find(params[:id])
    else
      ActivityType.new(activity_type_params)
    end
  end

  def activity_type_params
    return @_activity_sub_types if @_activity_sub_types

    params[:activity_type][:activity_sub_types_attributes] = params[:activity_type].delete(:activity_sub_types)
    @_activity_sub_types = params.require(:activity_type).permit(:name, :description, activity_sub_types_attributes: [:id, :name, :hours, :unlimited_hours, :_destroy])
  end
end
