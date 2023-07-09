class Student < ApplicationRecord
  include Persons

  belongs_to :person, dependent: :destroy
  belongs_to :career
  has_many :activity_week_participants, as: :participable

  delegate :name, to: :career, prefix: true

  validates_presence_of :hours, :career

  accepts_nested_attributes_for :person

  class << self
    def search(params)
      scope = where({})
      scope = global_search(params[:search]) if params[:search].present?
      scope = scope.where(career_id: params[:career_id]) if params[:career_id].present?
      scope
    end
  end

  def career_formatter
    career_name
  end
end
