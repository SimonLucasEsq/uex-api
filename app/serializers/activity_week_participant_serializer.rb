class ActivityWeekParticipantSerializer < ActiveModel::Serializer
  attributes :id, :activity_week_id, :hours, :evaluation, :participable_id, :participable_type, :participable

  belongs_to :activity_week

  def participable
    "#{object.participable_type.capitalize}Serializer".constantize.new(object.participable)
  end
end
