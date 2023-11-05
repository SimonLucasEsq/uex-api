class Student < ApplicationRecord
  include Persons

  # Defines hours to be submitted
  MAX_HOURS = 40

  enum status: {
    insuficient: 0,
    to_be_submitted: 1,
    submitted: 2
  }

  belongs_to :person, dependent: :destroy
  belongs_to :career
  has_many :activity_week_participants, as: :participable

  delegate :name, to: :career, prefix: true

  validates_presence_of :hours, :career, :status

  accepts_nested_attributes_for :person

  class << self
    def search(params)
      scope = where({})
      scope = global_search(params[:search]) if params[:search].present?
      scope = scope.where(career_id: params[:career_id]) if params[:career_id].present?
      scope = scope.where(status: params[:status]) if params[:status].present?
      scope
    end

    def eligible_status(student)
      return :submitted if student.submitted?

      student.hours < MAX_HOURS ? :insuficient : :to_be_submitted
    end

    def update_hours(student, hours)
      student.hours = hours
      student.status =  Student.eligible_status(student)
    end
  end

  def career_formatter
    career_name
  end
end
