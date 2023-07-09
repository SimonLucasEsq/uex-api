class ActivityWeekParticipant < ApplicationRecord
  belongs_to :activity_week
  belongs_to :participable, polymorphic: true
  validates_presence_of :participable_id, :participable_type

  validates_uniqueness_of :participable_id, scope: [:activity_week_id, :participable_type]

  class << self
    def search(params)
      scope = where({})
      scope = where(activity_week_id: params[:activity_week_id]) if params[:activity_week_id]
      scope = where(entity_type: params[:entity_type]) if params[:entity_type]
      scope
    end
  end
end
