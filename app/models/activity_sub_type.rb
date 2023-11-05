class ActivitySubType < ApplicationRecord
  belongs_to :activity_type

  validates_presence_of :name
  validate :validate_limited_hours

  def validate_limited_hours
    errors.add(:hours, "en blanco") if hours.blank? && limited_hours?
  end

  def limited_hours?
    !unlimited_hours
  end

  class << self
    def search(params)
      scope = where({})
      scope = global_search(params[:search]) if params[:search]
      scope
    end

    def global_search(text)
      where("name ILIKE :search", search: "%#{text}%")
    end
  end
end