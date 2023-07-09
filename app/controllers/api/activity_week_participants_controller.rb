class Api::ActivityWeekParticipantsController < Api::BaseController
  before_action :set_activity_week_participant, only: [:create, :show, :update, :destroy]

  def create
    @activity_week_participant.save!
    render json: @activity_week_participant
  end

  def index
    activity_week_participants = ActivityWeekParticipant.includes(includes).search(params).paginate(page: page, per_page: per_page)
    render json: activity_week_participants, each_serializer: ActivityWeekParticipantSerializer, meta: meta_attributes(activity_week_participants)
  end

  def show
    render json: @activity_week_participant
  end

  def update
    @activity_week_participant.update!(activity_week_participant_params)
    render json: @activity_week_participant
  end

  def destroy
    @activity_week_participant.destroy!
  end

  private
  def set_activity_week_participant
    @activity_week_participant = if params[:id]
      ActivityWeekParticipant.includes(includes).find(params[:id])
    else
      ActivityWeekParticipant.new(activity_week_participant_params)
    end
  end

  def includes
    [participable: [:person, :careers]]
  end

  def activity_week_participant_params
    params.require(:activity_week_participant).permit(:activity_week_id, :participable_id, :participable_type, :hours, :evaluation)
  end
end
