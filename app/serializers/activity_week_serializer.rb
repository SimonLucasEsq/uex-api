class ActivityWeekSerializer < ActiveModel::Serializer
  attributes :id, :activity_id, :start_date, :end_date
end
