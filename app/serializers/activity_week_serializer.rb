class ActivityWeekSerializer < ActiveModel::Serializer
  attributes :id, :activity_id, :start_date, :end_date

  def start_date
    I18n.l(object.start_date, format: :default)
  end
  def end_date
    I18n.l(object.end_date, format: :default)
  end
end
