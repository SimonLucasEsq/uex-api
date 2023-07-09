class Professor < ApplicationRecord
  include Persons

  belongs_to :person, dependent: :destroy
  has_many :professor_careers, dependent: :destroy
  has_many :careers, through: :professor_careers
  has_many :activity_week_participants, as: :participable

  accepts_nested_attributes_for :person
  accepts_nested_attributes_for :professor_careers, allow_destroy: true

  class << self
    def search(params)
      scope = where({})
      scope = global_search(params[:search]) if params[:search].present?
      scope = scope.joins(:careers).where(careers: params[:career_id]) if params[:career_id].present?
      scope
    end
  end

  def career_formatter
    careers.pluck(:name).join("-")
  end
end
