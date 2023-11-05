class ActivityType < ApplicationRecord
  validates_presence_of :name, :description
  has_many :activity_sub_types

  accepts_nested_attributes_for :activity_sub_types, allow_destroy: true

  class << self
    def search(params)
      scope = where({})
      scope = global_search(params[:search]) if params[:search]
      scope
    end

    def global_search(text)
      where("name ILIKE :search OR description ILIKE :search", search: "%#{text}%")
    end
  end
end
