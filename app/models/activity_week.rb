class ActivityWeek < ApplicationRecord
  belongs_to :activity
  has_many :activity_week_participants, dependent: :destroy

  accepts_nested_attributes_for :activity_week_participants, allow_destroy: true
  validates_presence_of :start_date, :end_date

  def self.search(params)
    scope = where({})
    scope = where(activity_id: params[:activity_id]) if params[:activity_id]
    scope
  end

  def date_formatted
    "#{start_date} - #{end_date}"
  end
end